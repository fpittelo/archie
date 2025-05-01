import logging
import azure.functions as func

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
        # For now, just echo the query back
        return func.HttpResponse(f"Archie received your query: '{query}'", status_code=200)
    else:
        logging.warning("Query parameter not found in the request.")
        return func.HttpResponse(
             "Please pass a 'query' parameter in the query string or request body",
             status_code=400
        )