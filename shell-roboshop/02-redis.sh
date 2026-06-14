#!/bin/bash

log_folder="/var/log/roboshop"
sudo mkdir -p $log_folder
sudo chown -R ec2-user:ec2-user $log_folder
sudo chmod -R 755 $log_folder
log_file="$log_folder/$0.log"

usr_id=$(id -u)

R="\e[31m" # Red color
G="\e[32m" # Green color
N="\e[0m"  # No color
Y="\e[33m" # Yellow color
time_stamnp=$(date "+%Y-%b-%d %H:%M:%S %Z")

if [ $usr_id -ne 0 ]; then
  echo -e "$time_stamnp [ERROR] ${R} Please run the script as root user or with sudo privileges.${N}" | tee -a $log_file
  exit 1
fi

validate() {
  if [ $1 -ne 0 ]; then
    echo -e "$time_stamnp [ERROR] ${R} $2 failed..${N}" | tee -a $log_file
    exit 1
  else
    echo -e "$time_stamnp [INFO] ${G} $2 succeeded.${N}" | tee -a $log_file
  fi
}

dnf module disable redis -y
dnf module enable redis:7 -y
dnf install redis -y &>> $log_file
validate $? "Installing Redis"


sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Updating Redis bind IP address to allow remote connections and disabling protected mode"

systemctl enable redis
systemctl start redis
validate $? "Starting and Enabling Redis service"


