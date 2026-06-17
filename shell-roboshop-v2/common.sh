#!/bin/bash

log_folder="/var/log/roboshop"
sudo mkdir -p $log_folder
sudo chown -R ec2-user:ec2-user $log_folder
sudo chmod -R 755 $log_folder
log_file="$log_folder/$0.log"
script_directory=$PWD

usr_id=$(id -u)

R="\e[31m" # Red color
G="\e[32m" # Green color
N="\e[0m"  # No color
Y="\e[33m" # Yellow color
time_stamnp=$(date "+%Y-%b-%d %H:%M:%S %Z")

echo -e "$time_stamp [INFO] script started"

check_root(){
    if [ $usr_id -ne 0 ]; then
        echo -e "$time_stamnp [ERROR] ${R} Please run the script as root user or with sudo privileges.${N}" | tee -a $log_file
        exit 1
    fi
}


validate() {
  if [ $1 -ne 0 ]; then
    echo -e "$time_stamnp [ERROR] ${R} $2 failed..${N}" | tee -a $log_file
    exit 1
  else
    echo -e "$time_stamnp [INFO] ${G} $2 succeeded.${N}" | tee -a $log_file
  fi
}


print_total_time(){
    echo -e "$time_stamp [INFO] script executed in $G $SECONDS seconds $N"
}


app_setup(){
  id roboshop &>> $log_file
  if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    validate $? "Creating roboshop system user"
  else
    echo -e "$time_stamnp [INFO] ${Y} roboshop user already exists, skipping user creation.${N}" | tee -a $log_file
  fi 
  
  rm -rf /app &>> $log_file
  validate $? "Removing existing application directory if it exists"

  mkdir -p /app &>> $log_file
  validate $? "Creating application directory"

  rm -rf /tmp/$app_name.zip &>> $log_file
  validate $? "Removing existing application archive if it exists"

  curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>> $log_file
  cd /app 
  unzip /tmp/$app_name.zip &>> $log_file
  validate $? "Extracting $app_name application code"
}

nodejs_setup(){
  dnf module disable nodejs -y &>> $log_file

  dnf module enable nodejs:20 -y &>> $log_file

  dnf install nodejs -y &>> $log_file
  validate $? "Installing NodeJS:20"

  npm install &>> $log_file
  validate $? "Installing $app_name application dependencies"
}

systemd_setup() {
  rm -rf /etc/systemd/system/$app_name.service &>> $log_file
  validate $? "Removing existing $app_name systemd service file if it exists"

  cp $script_directory/$app_name.service /etc/systemd/system/$app_name.service &>> $log_file
  validate $? "Copying $app_name systemd service file"

  systemctl daemon-reload
  systemctl enable $app_name &>> $log_file
  validate $? "enable $app_name"
}

app_restart(){
  systemctl restart $app_name &>> $log_file
  validate $? "Starting and Enabling $app_name service"
}