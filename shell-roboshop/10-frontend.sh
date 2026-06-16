
#!/bin/bash

log_folder="/var/log/roboshop"
sudo mkdir -p $log_folder
sudo chown -R ec2-user:ec2-user $log_folder
sudo chmod -R 755 $log_folder
log_file="$log_folder/$0.log"
script_directory=$PWD
MYSQL_HOST=mysql.avkc.online

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

dnf module disable nginx -y &>> $log_file
dnf module enable nginx:1.24 -y &>> $log_file
dnf install nginx -y &>> $log_file
validate $? "Installing Nginx"

rm -rf /usr/share/nginx/html/* 
validate $? "Removing default Nginx content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $log_file
validate $? "Downloading frontend application code"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> $log_file
validate $? "Extracting frontend application code"

rm -rf /etc/nginx/nginx.conf &>> $log_file
validate $? "Removing default Nginx configuration file" 

cp nginx.conf /etc/nginx/nginx.conf &>> $log_file
validate $? "Copying custom Nginx configuration file"

systemctl enable nginx &>> $log_file
systemctl restart nginx &>> $log_file
validate $? "Restarting Nginx service"




