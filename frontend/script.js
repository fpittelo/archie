document.addEventListener('DOMContentLoaded', () => {
    const queryForm = document.getElementById('query-form');
    const queryInput = document.getElementById('query-input');
    const resultsArea = document.getElementById('results-area');
    const loadingIndicator = document.getElementById('loading-indicator');
    const errorMessage = document.getElementById('error-message');
    const submitButton = document.getElementById('submit-button');

    queryForm.addEventListener('submit', async (event) => {
        event.preventDefault(); // Prevent default form submission (page reload)

        const query = queryInput.value.trim();
        if (!query) {
            showError("Please enter a query.");
            return;
        }

        // --- UI Updates ---
        resultsArea.textContent = ''; // Clear previous results
        errorMessage.style.display = 'none'; // Hide previous errors
        loadingIndicator.style.display = 'block'; // Show loading
        submitButton.disabled = true; // Disable button during request

        // --- API Call ---
        // !! IMPORTANT: Replace with your actual ADOIT API endpoint !!
        const apiEndpoint = '/api/adoit-query'; // <<<--- YOUR BACKEND ENDPOINT HERE

        // !! IMPORTANT: Add necessary authentication headers (e.g., Bearer token) !!
        // This will depend heavily on how your backend API is secured (e.g., Entra ID)
        const headers = {
            'Content-Type': 'application/json',
            // 'Authorization': 'Bearer YOUR_ACCESS_TOKEN' // <<<--- EXAMPLE AUTH HEADER
        };

        try {
            const response = await fetch(apiEndpoint, {
                method: 'POST', // Or 'GET' depending on your API design
                headers: headers,
                body: JSON.stringify({ query: query }) // Send the query in the request body
            });

            if (!response.ok) {
                // Try to get error details from the response body
                let errorData;
                try {
                    errorData = await response.json();
                } catch (e) {
                    // If response body is not JSON or empty
                    errorData = { message: response.statusText };
                }
                throw new Error(`API Error ${response.status}: ${errorData.message || 'Unknown error'}`);
            }

            const data = await response.json();

            // Display results (nicely formatted JSON in this example)
            resultsArea.textContent = JSON.stringify(data, null, 2); // Pretty print JSON

        } catch (error) {
            console.error("API Call Failed:", error);
            showError(`Failed to fetch results: ${error.message}`);
            resultsArea.textContent = 'An error occurred. Please check the console for details.'; // User-friendly fallback
        } finally {
            // --- UI Cleanup ---
            loadingIndicator.style.display = 'none'; // Hide loading
            submitButton.disabled = false; // Re-enable button
        }
    });

    function showError(message) {
        errorMessage.textContent = message;
        errorMessage.style.display = 'block';
    }
});
