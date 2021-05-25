#/bin/sh
set -e 

SETUPSH_INITIAL_FOLDER=$PWD

source create-folder-structure.sh
source vulniq-backend-install.sh
echo "---------------------------"
echo "Set VULNIQ_INSTALLATION_FOLDER to $VULNIQ_INSTALLATION_FOLDER for docker-compose"
echo "---------------------------"


cd "$SETUPSH_INITIAL_FOLDER"
echo "Copy ssl certificate and key files for webapp"
cp webapp/apache-certificate.crt "$VULNIQ_INSTALLATION_FOLDER/webapp/certs"
cp webapp/apache-privatekey.key "$VULNIQ_INSTALLATION_FOLDER/webapp/certs"

docker-compose -f docker-compose.yml build --build-arg VULNIQ_BUILD_DATE=$(date +'%s')

docker-compose -f docker-compose.yml up -d

echo "ONLY FOR NEW INSTALLATIONS:"
echo "---------------------------------------------"
echo "You can create the database using create-mysql-schema.sh once the mysql service starts."
echo "To create the elasticsearch schema, you can use create-elastic-schema.sh once the elastic service starts."
