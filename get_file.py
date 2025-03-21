import requests

url = "http://108.143.140.145:5000/generate_sas/mon_fichier.png"
response = requests.get(url)

if response.status_code == 200:
    with open("infamous.png", "wb") as f:
        f.write(response.content)
    print("infamous téléchargée avec succès !")
else:
    print("Erreur :", response.text)
