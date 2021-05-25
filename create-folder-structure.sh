#/bin/sh

echo "Checking required folders"
echo "Enter base installation folder path, e.g /vulniq. Defaults to ./vulniq-installation-folder. (Please note that this path cannot be changed/moved once created):"
read -e -p "Base folder: " PERM_DATA_FOLDER

if [ -z "$PERM_DATA_FOLDER" ]
then
    PERM_DATA_FOLDER="./vulniq-installation-folder"
else
    if [ "/" = "$PERM_DATA_FOLDER" ]
    then
        echo "Using / is dangerous. Cannot continue"
        exit
    fi
    #remove trailing /
    PERM_DATA_FOLDER=${PERM_DATA_FOLDER%/}
    if  [[ $PERM_DATA_FOLDER =~ ^/|^./|^../ ]]
    then
        echo "Path is in expected format"
    else
        PERM_DATA_FOLDER="./$PERM_DATA_FOLDER"
    fi
fi
PERM_DATA_FOLDER=$(realpath "$PERM_DATA_FOLDER")
echo "Using $PERM_DATA_FOLDER as the installation folder"
export VULNIQ_INSTALLATION_FOLDER="$PERM_DATA_FOLDER"

VULNIQ_FOLDERS=("backend" \
"elastic" \
    "elastic/data" \
    "elastic/logs" \
"mysql" \
    "mysql/var-lib-mysql" \
    "mysql/var-log-mysql" \
"permanent-storage-folder" \
    "permanent-storage-folder/__terzi" \
    "permanent-storage-folder/__terzi/scan" \
    "permanent-storage-folder/__terzi/system_info" \
"temp-files-folder" \
"webapp" \
    "webapp/certs" \
    "webapp/logs" \
"frontend" \
"webpage-renderer" \
    "webpage-renderer/logs")

if [[ ! -d "$PERM_DATA_FOLDER" ]]
then
    mkdir "$PERM_DATA_FOLDER"
    echo "    Creating $PERM_DATA_FOLDER"
else
    echo "    $PERM_DATA_FOLDER already exists"
fi

for tmpfolder in "${VULNIQ_FOLDERS[@]}"
do
    if [[ ! -d "$PERM_DATA_FOLDER/$tmpfolder" ]]
    then
        mkdir "$PERM_DATA_FOLDER/$tmpfolder"
        echo "    Creating $PERM_DATA_FOLDER/$tmpfolder"
    else
        echo "    $PERM_DATA_FOLDER/$tmpfolder already exists"
    fi
done

#this is required to allow docker write access to elasticsearch folders
chmod -R 777 "$PERM_DATA_FOLDER/elastic/data"
chmod -R 777 "$PERM_DATA_FOLDER/elastic/logs"