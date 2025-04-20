import React, { useState, useEffect } from "react";
import * as msal from "@azure/msal-browser";

const msalConfig = {
  auth: {
    clientId: "your_client_id", // Replace with your Azure AD App's client ID
    authority: "https://login.microsoftonline.com/your_tenant_id", // Replace with your tenant ID
    redirectUri: "http://localhost:3000", // Replace with your frontend's redirect URI
  },
};

const msalInstance = new msal.PublicClientApplication(msalConfig);

function App() {
  const [account, setAccount] = useState(null);
  const [query, setQuery] = useState("");
  const [response, setResponse] = useState(null);

  useEffect(() => {
    const accounts = msalInstance.getAllAccounts();
    if (accounts.length > 0) {
      setAccount(accounts[0]);
    }
  }, []);

  const handleLogin = async () => {
    try {
      const loginResponse = await msalInstance.loginPopup({
        scopes: ["openid", "profile", "email"],
      });
      setAccount(loginResponse.account);
    } catch (error) {
      console.error("Login failed:", error);
    }
  };

  const handleLogout = () => {
    msalInstance.logoutPopup();
    setAccount(null);
    window.location.href = "/login.html"; // Redirect to login page
  };

  const handleQuery = async () => {
    if (!account) {
      alert("Please log in first.");
      return;
    }

    try {
      const tokenResponse = await msalInstance.acquireTokenSilent({
        scopes: ["api://your_api_scope/.default"], // Replace with your API scope
        account,
      });

      const res = await fetch("http://localhost:5000/api/query", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${tokenResponse.accessToken}`,
        },
        body: JSON.stringify({ query }),
      });

      const data = await res.json();
      setResponse(data);
    } catch (error) {
      console.error("Error querying backend:", error);
      setResponse({ error: "Failed to fetch response from backend." });
    }
  };

  return (
    <div style={{ padding: "20px", fontFamily: "Arial, sans-serif" }}>
      {account && (
        <button
          onClick={handleLogout}
          style={{
            position: "absolute",
            top: "10px",
            left: "10px",
            padding: "10px 20px",
            backgroundColor: "#ff4d4d",
            color: "#fff",
            border: "none",
            borderRadius: "4px",
            cursor: "pointer",
          }}
        >
          Logout
        </button>
      )}
      <h1>Archie - ADOIT Integration</h1>
      {!account ? (
        <button onClick={handleLogin} style={{ padding: "10px 20px" }}>
          Login with Microsoft
        </button>
      ) : (
        <div>
          <p>Welcome, {account.username}</p>
        </div>
      )}
      <div style={{ marginTop: "20px" }}>
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Enter your query"
          style={{ width: "300px", padding: "10px", marginRight: "10px" }}
        />
        <button onClick={handleQuery} style={{ padding: "10px 20px" }}>
          Submit
        </button>
      </div>
      {response && (
        <div style={{ marginTop: "20px" }}>
          <h3>Response:</h3>
          <pre>{JSON.stringify(response, null, 2)}</pre>
        </div>
      )}
    </div>
  );
}

export default App;
