#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo 

validate $? "Copying MongoDB repo file"


dnf install mongodb-org -y &>> $log_file
validate $? "Installing MongoDB"

systemctl enable --now mongod 
validate $? "Starting and Enabling MongoDB service"


sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Updating MongoDB bind IP address to allow remote connections"

systemctl restart mongod
validate $? "Restarting MongoDB service to apply changes"

print_total_time