# Introduction
This installation package allows you to quickly set up all VulnIQ services as docker containers.

For production use with significant levels of load, deploying backend, mysql and webapps on a real operating system without 
using docker containers is recommended. 
Webpage renderer MUST ALWAYS run as a docker container.

**Please note:** 
In this document and scripts 'reporting-app' name is used for VulnIQ Vulnerability Manager web application (for historic reasons).

## Security
Docker setup exposes only https ports 443 and 8443. Mysql, elasticsearch and other docker containers do not expose any ports to the
host machine.

# Before You Begin

## License
You must obtain a vulniq.license file and place it into the same folder as docker-compose.yml and setup.sh.
Please contact support@vulniq.com to obtain a license.

## Customer access token
You must obtain an access token from https://license.vulniq.com or from VulnIQ support. This access token will be used by scripts to access product
downloads. Setup will fail without a valid access token.
Please make sure that you do not share access tokens with unauthorized parties.

# Preparing For Installation

## Installation Folder
During installation, i.e when you run setup.sh, you will be prompted to enter an installation folder. 
You must make sure that this folder structure is preserved as long as the services are in use so you should plan accordingly.
Docker containers will mount these folders and **services will fail if these folders or their contents are modified**.

If you want to perform an update/upgrade, you MUST use the same installation folder or it will result in a new separate clean installation.

**You can run `create-folder-structure.sh` script to create folders.** This script, which is also used internally by setup.sh, 
will only create missing folders if you already have some of the folders or somehow deleted some of them.

## Configuration options
You must edit `.env` file in this folder and update configuration options as necessary. You should not need to edit docker-compose.yml 
or other files. (On *nix systems, e.g linux, files starting with a . dot will be hidden, you can use "ls -a" to view hidden files.)


## SSL certificates for web applications
By default, webapp folder contains an invalid self-signed certificate (`apache-certificate.crt`file) and the corresponding private key 
(`apache-privatekey.key`file). To use a valid certificate, e.g issued by a CA, replace these files with new ones and rebuild the webapp container.
If you don't want to rebuild the container, you can place the new files into $VULNIQ_INSTALLATION_FOLDER/webapp/certs folder and restart the container.
Please note that Docker file and apache-site-*.conf files reference these files and you must use exactly the same file names.
This setup contains two web applications one for external data (engine) and one for internal data (reporting-app).
Reporting-app is used to store and view data collected by VulnIQ security analyzer, Terzi. Engine listens on port 443 and reporting-app
listens on port 8443.

# Installation

## Using setup.sh
To install VulnIQ services just run setup.sh.

### For the initial setup only (not during upgrades)
Wait for the containers to start up then run create-mysql-schema.sh and create-elastic-schema.sh scripts to create mysql and elasticsearch 
schemas.

### During upgrades
See release notes for instructions on applying database and/or elasticsearch schema and other release specific upgrade tasks.

**During the first installation only**
After the services start you need to run the following scripts to create mysql and elasticsearch schemas:
  -  `create-mysql-schema.sh`
  -  `create-elastic-schema.sh`

DO NOT run these scripts during updates/ugrades.

## Manual setup
Or you can run the commands manually yourself one by one, following the same order as setup.sh.
When you run docker-compose yourself, docker-compose cannot load data into mysql and elasticsearch services 
as the services need to be started before data can be loaded. Therefore **after** creating the services using docker-compose 
you need to run the steps detailed in **After running docker-compose** section below to initialize databases 
and load data.

### Create/verify permanent storage folders
As described in "Permanent storage" section above, a certain folder structure is required. 
`create-folder-structure.sh` should be used to create the necessary directory structure.

### Run docker-compose
You can use docker-compose to quickly set up and start all services.

See setup.sh for docker-compose commands.

### After running docker-compose
After running docker-compose for the first time, you need to create mysql database and elasticsearch schemas.

#### Mysql database setup
AFTER THE CONTAINER STARTS, you can run "docker exec -it vulniq_pro_mysql_1 /bin/bash" and run the following command in the container

```    
mysql -u root -p"$MYSQL_ROOT_PASSWORD"</vulniq/vulniq-db-schema.sql 
```
Dockerfile will have already downloaded and extracted /vulniq/vulniq-db-schema.sql so all you need to do is to run the above command
in the container.

Or you can simply run `create-mysql-schema.sh` script which will run the above command for you (the container must be running and 
the script uses the default container name).

This is only needed for the initial setup. If the database already exists, then you will get errors.

#### Elasticsearch schema
AFTER THE CONTAINER STARTS, run "docker exec -it vulniq_pro_elastic_1 /bin/bash" and run the following command in the container
to  create the elasticsearch schema used by VulnIQ.

```
    /vulniq/elastic-schema-create.sh
```
Dockerfile will have already downloaded and extracted /vulniq/elastic-schema-create.sh so all you need to do is to run the above command
in the container.

Or you can simply run `create-elastic-schema.sh` script which will run the above command for you (the container must be running and 
the script uses the default container name).

This is only needed for the initial setup. If the schema already exists, then you will get errors.

# Post Installation
You can review individual service configurations and modify advanced configuration options. Please use additional care when editing configuration files.

## Backend configuration
Backend provides the most configuration options such as screenshot service configurations. See configuration files in backend/conf/ folder file for details.
Files in this folder contain advanced configuration options and might break your setup if edited incorrectly.

### vulniq.properties
This file contains main application configuration. Please see comments inline.


# Operations
All docker-compose commands are assumed to be run from the folder that contains docker-compose.yml (this folder).

## Using the services
Only port 443 and 8443 are exposed outside the docker network. 
Mysql, elasticsearch and webpage renderer are only accessible from other docker containers.

For web apps go to:
  -  https://hostname-or-IP information engine(external data)
  -  https://hostname-or-IP:8443 reporting app(internal data)

## Starting services
To start all services in detached mode, you can use the following command:
```
docker-compose -f docker-compose.yml up -d
```
This will start all services and docker-compose will exit. Containers will continue to work.

To start all services, you can also use the same command without the -d option. In that case docker-compose will not exit
after starting the containers and will continue to output logs from containers.
Once docker-compose is killed (e.g you press Ctrl+C) all containers will be stopped. Running in detached mode (with -d option) is recommended.

To start an individual service, for example mysql, you can use the following command:
```
docker-compose -f docker-compose.yml up mysql
```

To rebuild an individual service, for example mysql, you can use the following command (you should not need this under normal 
circumstances):
```
docker-compose -f docker-compose.yml build mysql
```


## Stopping services

```
docker-compose -f docker-compose.yml stop
```
This command will stop all containers defined in docker-compose.yml. You can use this command when you used detached (-d) option to start containers.

To stop an individual service, for example mysql, you can use the following command:
```
docker-compose -f docker-compose.yml stop mysql
```
## Monitoring
When creating support tickets you might be asked to provide relevant logs. Logs will be written into folders mounted on the host, so you 
will not need to search containers to locate logs. Using mounted folders also allows log persistence over container/image rebuilds.

VulnIQ logs can be found in the following locations:

### Backend
Backend logs will be written into VULNIQ_INSTALLATION_FOLDER/backend/logs. 

  - vulniq-health.log contains logs that require administrative action
  - vulniq.log contains application logs
  - app.log contains additional logs, e.g debug logs or similar
  - gc.log file contains java garbage collection logs

### Web app logs
Web application and web server logs will be written into VULNIQ_INSTALLATION_FOLDER/webapp/logs. 

### Elasticsearch
Elasticsearch logs will be written into VULNIQ_INSTALLATION_FOLDER/logs.

### Mysql logs
Mysql logs will be written into VULNIQ_INSTALLATION_FOLDER/mysql/var-log-mysql.

### Webpage renderer logs
Webpage renderer logs will be written into VULNIQ_INSTALLATION_FOLDER/webpage-renderer/viq-webpage-renderer-logs.