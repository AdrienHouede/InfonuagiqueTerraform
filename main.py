from flask import Flask, request, jsonify
from azure.storage.blob import BlobServiceClient, generate_blob_sas, BlobSasPermissions
from datetime import datetime, timedelta
import os

app = Flask(__name__)

# Configuration
account_name = "adrienstorageacct"
with open('/path/to/your/python/script/account_key.txt', 'r') as file:
    account_key = file.read().strip()
container_name = "statics"

blob_service_client = BlobServiceClient(account_url=f"https://{account_name}.blob.core.windows.net", credential=account_key)
container_client = blob_service_client.get_container_client(container_name)

### **Upload un fichier**
@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400

    file = request.files['file']
    blob_client = container_client.get_blob_client(file.filename)

    try:
        blob_client.upload_blob(file, overwrite=True)
        return jsonify({"message": "File uploaded successfully!"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

### **Générer un SAS Token pour un fichier spécifique**
@app.route('/generate_sas/<filename>', methods=['GET'])
def generate_sas(filename):
    try:
        sas_token = generate_blob_sas(
            account_name=account_name,
            container_name=container_name,
            blob_name=filename,
            account_key=account_key,
            permission=BlobSasPermissions(read=True, write=True, delete=True),
            expiry=datetime.utcnow() + timedelta(hours=1)
        )

        file_url = f"https://{account_name}.blob.core.windows.net/{container_name}/{filename}?{sas_token}"
        return jsonify({"sas_url": file_url})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
