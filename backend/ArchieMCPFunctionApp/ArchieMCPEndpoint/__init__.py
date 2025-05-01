import logging
import os
import azure.functions as func
from openai import AzureOpenAI # Use AzureOpenAI if deploying to Azure with managed identity or key in settings
# from openai import OpenAI # Or use standard OpenAI if preferred

# --- OpenAI Configuration ---
# It's recommended to use environment variables for API keys and endpoints
openai_api_key = os.environ.get("OPENAI_API_KEY")
# You might need to set OPENAI_API_VERSION and AZURE_OPENAI_ENDPOINT as environment variables too
# depending on your OpenAI setup (Azure OpenAI vs standard OpenAI)

# Initialize the OpenAI client
# Ensure your Function App has the OPENAI_API_KEY application setting configured
if not openai_api_key:
    logging.error("OpenAI API key not found in environment variables.")
    # Handle the error appropriately - maybe return an error response
    # For now, we'll let it fail later if the key is missing

# Example using AzureOpenAI (adjust if using standard OpenAI)
# client = AzureOpenAI(
#     api_key=openai_api_key,
#     # api_version="YOUR_API_VERSION", # e.g., "2023-07-01-preview" - Set via env var preferably
#     # azure_endpoint="YOUR_AZURE_OPENAI_ENDPOINT" # Set via env var preferably
# )
# --- OR ---
# Example using standard OpenAI client
client = AzureOpenAI(api_key=openai_api_key) # Assuming standard OpenAI for simplicity now
# --- End OpenAI Configuration ---

def main(req: func.HttpRequest) -> func.HttpResponse:
    """
    Azure Function endpoint to receive queries from the Archie frontend.
    """
    logging.info('Python HTTP trigger function processed a request.')

    # Get the 'query' parameter from the request query string
    query = req.params.get('query')

    if not query:
        try:
            # If not in query string, try the request body (for POST)
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            query = req_body.get('query')

    if query:
        logging.info(f"Received query: {query}")

        if not openai_api_key:
             logging.error("OpenAI API key is not configured.")
             return func.HttpResponse("Server configuration error: OpenAI API key missing.", status_code=500)

        try:
            # --- Call OpenAI ---
            # Define a system message (optional but recommended)
            system_message = """
            You are Archie, an AI assistant knowledgeable about the EPFL Enterprise Architecture repository managed in ADOIT.
            Answer the user's questions clearly and concisely based on the information typically found in such repositories.
            For now, you don't have direct access to the repository data, so answer based on general knowledge
            of enterprise architecture concepts and what might be plausible for EPFL.
            If you cannot answer definitively, say so.
            """

            response = client.chat.completions.create(
                model="gpt-3.5-turbo", # Or your preferred model
                messages=[
                    {"role": "system", "content": system_message},
                    {"role": "user", "content": query}
                ]
            )
            ai_response = response.choices[0].message.content
            return func.HttpResponse(ai_response, status_code=200, mimetype="text/plain")
        except Exception as e:
            logging.error(f"Error calling OpenAI or processing request: {e}")
            return func.HttpResponse(f"An error occurred while processing your query: {e}", status_code=500)
    else:
        logging.warning("Query parameter not found in the request.")
        return func.HttpResponse(
             "Please pass a 'query' parameter in the query string or request body",
             status_code=400
        )