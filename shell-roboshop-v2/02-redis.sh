#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>> $log_file
dnf module enable redis:7 -y &>> $log_file
dnf install redis -y &>> $log_file
validate $? "Installing Redis"


sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Updating Redis bind IP address to allow remote connections and disabling protected mode"

systemctl enable redis
systemctl start redis
validate $? "Starting and Enabling Redis service"


print_total_time