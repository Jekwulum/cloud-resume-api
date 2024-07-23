import azure.functions as func
import os
import logging
import pymongo
from dotenv import load_dotenv
from bson import json_util

load_dotenv()
database_connection_string = os.getenv("COSMOSDB_CONNECTION_STRING")
database_name = os.getenv("COSMOSDB_DATABASE_NAME")
database_collection_name = os.getenv("COSMOSDB_COLLECTION_NAME")

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)

@app.route(route="resume")
def resume(req: func.HttpRequest) -> func.HttpResponse:
    """A http trigger to return a resume in JSON format from a CosmosDB collection"""
    try:
        client = pymongo.MongoClient(database_connection_string)
    except Exception as e:
        logging.error(f"Error establishing connection to CosmosDB: {str(e)}")
        return func.HttpResponse(body=f"Error establishing connection to CosmosDB: {str(e)}", status_code=500)

    database = client[database_name]
    collection = database[database_collection_name]

    id = req.params.get('id')

    if not id:
        return func.HttpResponse("Kindly pass an id in the query string", status_code=400)
    else:
        doc = collection.find_one({"id": str(id)})
        if doc:
            return func.HttpResponse(body=json_util.dumps(doc), status_code=200, mimetype="application/json")
        else:
            return func.HttpResponse(f"No document found for the id: {id}", status_code=404)
