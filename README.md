# InfonuagiqueTerraform

Prérequis : 

Avoir Terraform, python3 et pip3 installer

## Les commandes dans l'ordre pour faire fonctionner l'application flask : 

git clone https://github.com/AdrienHouede/InfonuagiqueTerraform.git

cd InfonuagiqueTerraform

### Modifier le fichier terraform.tfvars avec avec la cle de votre account

## Il faut ensuite avoir Terraform d'installer, et avoir renseigné le chemin dasn les variables d'environnment

terraform plan -> taper un mot de passe de plus de 12 caractères, un symbole spécial et un chiffre au minimum

terraform apply -> taper le même mot de passe 

## Si tout se passe bien : 

python3 post_file.py -> pour uploader une image 

python3 modify_file.py -> pour télécharger une image 

python3 get_file.py -> pour uploadtélécharger une image 

## Si les scripts renvoient des erreurs, il va falloir se connecter à la vm donc depuis un terminal : 

ssh adrien@<ip_renvoyé_par_le_apply>

"taper le même mdp que lors du terraform apply"

## Vérifier ensuite la bonne exécution de ces commandes : 
### Lors de la dernière commande le terminal devrait vous ajouter les requètes lorsque vous exécuter les scripts python *_file.py

sudo apt-get update
sudo apt-get install python3-dev build-essential libssl-dev libffi-dev cargo
git clone https://github.com/AdrienHouede/InfonuagiqueTerraform.git /home/adrien/InfonuagiqueTerraform
cd /home/adrien/InfonuagiqueTerraform
pip3 install --upgrade pip
pip3 install setuptools-rust
pip3 install -r requirements.txt
export ACCOUNT_KEY=$(terraform output -raw account_key)
python3 /home/adrien/InfonuagiqueTerraform/main.py

## Pour finir n'oubliez pas le terraform destroy ;)