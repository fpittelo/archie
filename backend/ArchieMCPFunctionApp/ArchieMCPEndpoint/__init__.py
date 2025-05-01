import logging
import os
import azure.functions as func
from openai import AzureOpenAI # Use AzureOpenAI if deploying to Azure with managed identity or key in settings
from openai import OpenAI # Use standard OpenAI client if using api.openai.com


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

        # --- OpenAI Configuration & Client Initialization ---
        openai_api_key = os.environ.get("OPENAI_API_KEY")

        if not openai_api_key:
             logging.error("OpenAI API key is not configured.")
             return func.HttpResponse("Server configuration error: OpenAI API key missing.", status_code=500)

        try:
            # Initialize the client *inside* the function call
            # Use the correct client based on your service (OpenAI vs Azure OpenAI)

            # Option 1: Standard OpenAI API
            client = OpenAI(api_key=openai_api_key)

            # Option 2: Azure OpenAI Service (Requires additional settings)
            # azure_endpoint = os.environ.get("AZURE_OPENAI_ENDPOINT")
            # api_version = os.environ.get("AZURE_OPENAI_API_VERSION") # e.g., "2023-12-01-preview"
            # if not azure_endpoint or not api_version:
            #     logging.error("Azure OpenAI endpoint or API version not configured.")
            #     return func.HttpResponse("Server configuration error: Azure OpenAI settings missing.", status_code=500)
            # client = AzureOpenAI(api_key=openai_api_key, azure_endpoint=azure_endpoint, api_version=api_version)

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