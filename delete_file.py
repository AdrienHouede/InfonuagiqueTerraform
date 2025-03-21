import requests

sas_url = "https://adrienstorageacct.blob.core.windows.net/statics/mon_fichier.pdf?st=...&se=...&sp=rw"

response = requests.delete(sas_url)

if response.status_code == 202:
    print("Fichier supprimé avec succès !")
else:
    print("Erreur lors de la suppression :", response.text)
