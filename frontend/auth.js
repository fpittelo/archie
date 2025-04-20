// auth.js

// --- MSAL Configuration ---
// IMPORTANT: Replace placeholders with your actual Entra ID App Registration details
const msalConfig = {
    auth: {
        clientId: "YOUR_APPLICATION_CLIENT_ID", // <<< Get this from Entra ID App Registration
        authority: "https://login.microsoftonline.com/YOUR_EPFL_TENANT_ID", // <<< Use EPFL's Tenant ID or domain
        redirectUri: window.location.origin + "/", // <<< Must match one registered in Entra ID (e.g., http://localhost:PORT/ or https://archie.epfl.ch/)
        // postLogoutRedirectUri: window.location.origin + "/", // Optional: Where to redirect after logout
    },
    cache: {
        cacheLocation: "sessionStorage", // Or 'localStorage' for persistence across browser sessions
        storeAuthStateInCookie: false, // Set to true if you have issues with IE11/Safari
    },
    system: {
        loggerOptions: {
            loggerCallback: (level, message, containsPii) => {
                if (containsPii) {
                    return;
                }
                switch (level) {
                    case msal.LogLevel.Error:
                        console.error(message);
                        return;
                    case msal.LogLevel.Info:
                        // console.info(message); // Avoid verbose logging in production
                        return;
                    case msal.LogLevel.Verbose:
                        // console.debug(message);
                        return;
                    case msal.LogLevel.Warning:
                        console.warn(message);
                        return;
                }
            }
        }
    }
};

// --- MSAL Instance ---
const msalInstance = new msal.PublicClientApplication(msalConfig);

// --- DOM Elements ---
const loginButton = document.getElementById("login-button");
const errorDiv = document.getElementById("login-error");
const loadingDiv = document.getElementById("login-loading");

// --- Login Request Configuration ---
// Define the scopes your application needs.
// 'openid', 'profile', 'email' are standard OIDC scopes.
// You might need specific scopes to call your backend API later.
const loginRequest = {
    scopes: ["openid", "profile", "email"] // Add API scopes if needed e.g., "api://YOUR_BACKEND_API_CLIENT_ID/access_as_user"
};

// --- Event Listener for Login Button ---
if (loginButton) {
    loginButton.addEventListener("click", () => {
        showLoading(true);
        showError(null); // Clear previous errors

        // Use loginRedirect to start the sign-in process
        msalInstance.loginRedirect(loginRequest)
            .catch(error => {
                console.error("Login Redirect Error:", error);
                showError("Login failed. Please try again. Check console for details.");
                showLoading(false);
            });
    });
}

// --- Handle Redirect ---
// MSAL needs to handle the redirect back from Entra ID.
// This promise resolves if the page is loaded after a successful redirect.
msalInstance.handleRedirectPromise()
    .then(response => {
        if (response) {
            // Redirect successful, user is logged in.
            // You might want to store account info or redirect to the main app page.
            console.log("Login successful via redirect:", response);
            // Redirect to the main application page (index.html)
            window.location.replace("index.html"); // Use replace to avoid login page in history
        } else {
            // This is not a redirect call, check if user is already logged in
            const accounts = msalInstance.getAllAccounts();
            if (accounts.length > 0) {
                // User is already logged in, redirect to main app
                console.log("User already logged in:", accounts[0]);
                window.location.replace("index.html");
            }
            // Otherwise, stay on the login page waiting for button click.
        }
    })
    .catch(error => {
        console.error("Handle Redirect Error:", error);
        // Handle specific errors (e.g., interaction_required, consent_required)
        showError("An error occurred after login redirect. Check console for details.");
        showLoading(false); // Hide loading if it was shown
    });


// --- Helper Functions ---
function showError(message) {
    if (errorDiv) {
        errorDiv.textContent = message;
        errorDiv.style.display = message ? 'block' : 'none';
    }
}

function showLoading(isLoading) {
    if (loadingDiv && loginButton) {
        loadingDiv.style.display = isLoading ? 'block' : 'none';
        loginButton.disabled = isLoading;
    }
}

// --- Optional: Function to acquire token silently for API calls (used in index.html's script) ---
// You would call this function from your main application page (index.html)
// before making calls to your protected backend API.
async function getAccessToken() {
    const accounts = msalInstance.getAllAccounts();
    if (accounts.length === 0) {
        // No user signed in, potentially redirect to login
        // Or handle as appropriate for your app
        console.warn("No user signed in to acquire token.");
        // Optional: Trigger interactive login if needed
        // msalInstance.loginRedirect(loginRequest);
        return null;
    }

    const request = {
        scopes: ["api://YOUR_BACKEND_API_CLIENT_ID/access_as_user"], // <<< Use the scope for YOUR backend API
        account: accounts[0] // Use the first logged-in account
    };

    try {
        const response = await msalInstance.acquireTokenSilent(request);
        return response.accessToken;
    } catch (error) {
        console.error("Silent token acquisition failed:", error);
        if (error instanceof msal.InteractionRequiredAuthError) {
            // Fallback to interactive method if silent fails
            try {
                const response = await msalInstance.acquireTokenRedirect(request); // Or acquireTokenPopup
                return response.accessToken;
            } catch (interactiveError) {
                console.error("Interactive token acquisition failed:", interactiveError);
                showError("Could not acquire necessary permissions. Please try logging in again.");
                return null;
            }
        } else {
            showError("Failed to acquire token. Check console for details.");
            return null;
        }
    }
}

// --- Optional: Logout Function ---
function logout() {
    const accounts = msalInstance.getAllAccounts();
    if (accounts.length > 0) {
        const logoutRequest = {
            account: accounts[0],
            // postLogoutRedirectUri: msalConfig.auth.postLogoutRedirectUri // Optional
        };
        msalInstance.logoutRedirect(logoutRequest); // Or logoutPopup
    } else {
        // No user to log out, maybe just clear local state if needed
        sessionStorage.clear(); // Or localStorage.clear();
        window.location.replace("login.html"); // Go back to login page
    }
}

// Example: Add a logout button handler if you have one in index.html
// const logoutButton = document.getElementById('logout-button');
// if (logoutButton) {
//     logoutButton.addEventListener('click', logout);
// }
