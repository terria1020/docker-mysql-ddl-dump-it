#!/bin/bash
echo "service mysql on for use client"
service mysql start

echo "wait for db init" 
sleep $WAIT

echo "dump to it"
mysqldump -u $ORG_USER -p$ORG_PASSWORD --host $ORG_HOST --databases $ORG_DB --no-data --set-gtid-purged=OFF --column-statistics=0 > /root/all_ddl.sql
sed "s/$ORG_HOST/localhost/g" /root/all_ddl.sql > /root/all_ddl.sql.new
mv /root/all_ddl.sql.new /root/all_ddl.sql

echo "drop and create database"
echo y | mysqladmin -u root -p$MYSQL_ROOT_PASSWORD --host $MYSQL_SERVICENAME --port 3306 drop $ORG_DB
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD --host $MYSQL_SERVICENAME --port 3306 create $ORG_DB

echo "pump to it"
mysql -u root -p$MYSQL_ROOT_PASSWORD --host $MYSQL_SERVICENAME --port 3306 $ORG_DB < /root/all_ddl.sql

echo "dump finished!"