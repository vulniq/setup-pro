#!/bin/bash

#exit on error
set -e

VULNIQ_BUILD_DATE=$(date +'%s')

#if first param is not set, env var must be set otherwise the script will fail
if [ ! -z "$1" ];
then
    VULNIQ_INSTALLATION_FOLDER="$1"
fi

#if second param is not set, env var must be set
if [ ! -z "$2" ];
then
    VULNIQ_CUSTOMER_ACCESS_TOKEN="$2"
fi

echo "VULNIQ_INSTALLATION_FOLDER = $VULNIQ_INSTALLATION_FOLDER"
echo "VULNIQ_CUSTOMER_ACCESS_TOKEN = $VULNIQ_CUSTOMER_ACCESS_TOKEN"

if [ -z "$VULNIQ_INSTALLATION_FOLDER" ];
then
    echo "VULNIQ_INSTALLATION_FOLDER is not set. It can be passed as the first parameter to this script or VULNIQ_INSTALLATION_FOLDER environment variable should be set"
    exit 1
fi

if [ -z "$VULNIQ_CUSTOMER_ACCESS_TOKEN" ];
then
    echo "VULNIQ_CUSTOMER_ACCESS_TOKEN is not set. It can be passed as the second parameter to this script or VULNIQ_CUSTOMER_ACCESS_TOKEN environment variable should be set. A valid access token is required to download program packages"
    exit 2
fi

RESTORE_VULNIQ_CONF="no"

INITIAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo "$INITIAL_DIR"

cd "$VULNIQ_INSTALLATION_FOLDER/backend"


if [ -d "conf" ]; 
then
    echo "conf folder already exists, creating a backup of existing files and folders"
    mkdir "vulniq_backup_$VULNIQ_BUILD_DATE"    
    mv "conf"  "vulniq_backup_$VULNIQ_BUILD_DATE/conf"
    #we assume lib and bin also exists if conf exists
    mv "lib"  "vulniq_backup_$VULNIQ_BUILD_DATE/lib"
    mv "bin"  "vulniq_backup_$VULNIQ_BUILD_DATE/bin"
    RESTORE_VULNIQ_CONF="yes"
fi

echo "Downloading VulnIQ backend installation package..."

if [ -x "$(wget --version)" ];
then
    wget -O VulnIQBackend.zip --header="Authorization: Bearer $VULNIQ_CUSTOMER_ACCESS_TOKEN" https://license.vulniq.com/download/VulnIQBackend.zip?date=$VULNIQ_BUILD_DATE
else
    curl -o VulnIQBackend.zip -H "Authorization: Bearer $VULNIQ_CUSTOMER_ACCESS_TOKEN" https://license.vulniq.com/download/VulnIQBackend.zip?date=$VULNIQ_BUILD_DATE
fi

if [ ! -s "VulnIQBackend.zip" ]; then
    echo "Failed to download VulnIQBackend.zip. Cannot continue. Either wget or curl and a valid VulnIQ access token is required for this script. "
    exit 3;
fi


unzip VulnIQBackend.zip
mv VulnIQBackend-*/* ./
rm -Rf VulnIQBackend-*
rm  VulnIQBackend.zip

if [ $RESTORE_VULNIQ_CONF = "yes" ]; 
then
    mv conf conf_NEW-$VULNIQ_BUILD_DATE
    mv "vulniq_backup_$VULNIQ_BUILD_DATE/conf" "conf"
    echo "Your existing conf folder has been preserved and the default conf in the new version has been saved as conf_NEW-$VULNIQ_BUILD_DATE, you should review new configuration files and add any missing properties to your configuration"
    echo "Existing bin and lib folders has been backed up in vulniq_backup_$VULNIQ_BUILD_DATE folder, you can delete this folder once the new version is verified"
else
    cp $INITIAL_DIR/vulniq.license conf/
fi



echo "Finished installing VulnIQ backend"