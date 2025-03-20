from flask import Flask, request, jsonify
from azure.storage.blob import BlobServiceClient
import os

app = Flask(__name__)

account_name = "adrienstorageacct"
account_key = "VMMk39M4oV8BfcoCM4X2z8ENYsuvd8XVbl0U5Mlz9JiD69cCCkwkqJjDYVXeQHyOxq5SaZCditTo+AStbQUGgw=="
container_name = "statics"
blob_service_client = BlobServiceClient(account_url=f"https://{account_name}.blob.core.windows.net", credential=account_key)
container_client = blob_service_client.get_container_client(container_name)

@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    blob_client = container_client.get_blob_client(file.filename)
    blob_client.upload_blob(file, overwrite=True)
    return jsonify({"message": "File uploaded successfully!"})

@app.route('/download/<filename>', methods=['GET'])
def download_file(filename):
    blob_client = container_client.get_blob_client(filename)
    download_stream = blob_client.download_blob()
    return download_stream.readall()

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
