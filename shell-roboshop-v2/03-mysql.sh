#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>> $log_file
validate $? "Installing MySQL Server"

systemctl enable mysqld
systemctl start mysqld  
validate $? "Starting and Enabling MySQL service"

mysql_secure_installation --set-root-pass RoboShop@123 &>> $log_file
validate $? "Setting MySQL root password"

print_total_time