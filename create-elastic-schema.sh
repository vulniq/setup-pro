#/bin/sh

echo "Creating elasticsearch schema"

docker exec vulniq_pro_elastic_1 /bin/bash /vulniq/elastic-schema-create.sh

echo 
echo "Done"