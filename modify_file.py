import requests
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
from io import BytesIO

url = "http://108.143.140.145:5000/generate_sas/mon_fichier.pdf"
response = requests.get(url)

if response.status_code == 200:
    data = response.json()
    sas_url = data.get("sas_url")
    print(response.text)
else:
    print("Erreur :", response.text)

blob_client = BlobClient.from_blob_url(sas_url)

new_content = "Nouveau contenu du fichier."

new_content_bytes = BytesIO(new_content.encode('utf-8'))

blob_client.upload_blob(new_content_bytes, overwrite=True)

print("Fichier mis à jour avec succès.")