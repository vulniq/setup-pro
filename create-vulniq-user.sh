#!/bin/bash
echo "This script will create a new VulnIQ user. By default users created by this script "
echo "will NOT have administrator privileges except the VIQ_SUPER_USER_EMAIL defined in .env"
echo "After initial setup, you should create a user that matches the VIQ_SUPER_USER_EMAIL you defined in .env"
echo 
echo "Enter user email and press enter:"
read USERNAME
echo "Enter user password and press enter:"
read PASSWORD
echo "Enter user display name and press enter:"
read NAME
docker exec -it vulniq_pro_webapp_1 php -r "define('VIQ_FILE_INCLUDED_PROPERLY','yes'); include(getenv('VIQ_PHPLIB_PATH').'/common.php'); include('/vulniq/frontend/vulniq-webapp/conf/app-configuration.php'); print_r(VIQ_User::CreateLocalUser(array('email'=>'$USERNAME', 'password'=>'$PASSWORD','displayName'=>'$NAME', 'verifiedStatus'=>'Verified'))); echo PHP_EOL;" 
