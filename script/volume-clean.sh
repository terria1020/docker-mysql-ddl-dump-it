#!/bin/bash
echo "you must execute this script after compose down."
echo "volume cleanup"
docker volume rm dump-and-server_dumped-mysql-vol