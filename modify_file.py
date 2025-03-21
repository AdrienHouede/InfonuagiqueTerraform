import requests

sas_url = "https://adrienstorageacct.blob.core.windows.net/statics/mon_fichier.pdf?st=...&se=...&sp=rw"

file_path = "nouveau_fichier.pdf"

with open(file_path, "rb") as file:
    response = requests.put(sas_url, data=file)

if response.status_code == 201:
    print(f"{file_path} modifié avec succès !")
else:
    print("Erreur lors de la modification :", response.text)
