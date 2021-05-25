#/bin/sh

echo "Creating database schema"
docker exec vulniq_pro_mysql_1 /bin/bash -c '/usr/bin/mysql -u root -p''$MYSQL_ROOT_PASSWORD''</vulniq/vulniq-db-schema.sql' 