
#!/bin/bash

log_folder="/var/log/roboshop"
sudo mkdir -p $log_folder
sudo chown -R ec2-user:ec2-user $log_folder
sudo chmod -R 755 $log_folder
log_file="$log_folder/$0.log"
script_directory=$pwd

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




dnf module disable nodejs -y &>> $log_file

dnf module enable nodejs:20 -y &>> $log_file

dnf install nodejs -y &>> $log_file
validate $? "Installing NodeJS:20"


id roboshop &>> $log_file
if [ $? -ne 0 ]; then
  useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
  validate $? "Creating roboshop system user"
 else
  echo -e "$time_stamnp [INFO] ${Y} roboshop user already exists, skipping user creation.${N}" | tee -a $log_file
fi 

rm -rf /app &>> $log_file
validate $? "Removing existing application directory if it exists"

mkdir /app &>> $log_file
validate $? "Creating application directory"

rm -rf /tmp/catalogue.zip &>> $log_file
validate $? "Removing existing application archive if it exists"

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip  &>> $log_file
cd /app 
unzip /tmp/catalogue.zip &>> $log_file
validate $? "Extracting catalogue application code"

cd /app
npm install &>> $log_file
validate $? "Installing catalogue application dependencies"

rm -rf /etc/systemd/system/catalogue.service &>> $log_file
validate $? "Removing existing catalogue systemd service file if it exists"

cp $script_directory/catalogue.service /etc/systemd/system/catalogue.service &>> $log_file
validate $? "Copying catalogue systemd service file"

rm -rf /etc/yum.repos.d/mongo.repo &>> $log_file
validate $? "Removing existing MongoDB repo file if it exists"

cp $script_directory/mongo.repo /etc/yum.repos.d/mongo.repo &>> $log_file
validate $? "Copying MongoDB repo file"

dnf install mongodb-mongosh -y &>> $log_file
validate $? "Installing MongoDB client"















