import requests

url = "http://108.143.140.145:5000/upload"
files = {"file": open("C:/Users/adrie/OneDrive/Images/infamous.png", "rb")}
response = requests.post(url, files=files)

print(response.text)
