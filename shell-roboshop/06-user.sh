
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
  useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $log_file
  validate $? "Creating roboshop system user"
 else
  echo -e "$time_stamnp [INFO] ${Y} roboshop user already exists, skipping user creation.${N}" | tee -a $log_file
fi 

rm -rf /app &>> $log_file
validate $? "Removing existing application directory if it exists"

mkdir -p /app &>> $log_file
validate $? "Creating application directory"

rm -rf /tmp/user.zip &>> $log_file
validate $? "Removing existing application archive if it exists"

curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user-v3.zip  &>> $log_file
cd /app 
unzip /tmp/user.zip &>> $log_file
validate $? "Extracting user application code"

npm install &>> $log_file
validate $? "Installing user application dependencies"

rm -rf /etc/systemd/system/user.service &>> $log_file
validate $? "Removing existing user systemd service file if it exists"

cp $script_directory/user.service /etc/systemd/system/user.service &>> $log_file
validate $? "Copying user systemd service file"


systemctl enable user &>> $log_file
systemctl restart user &>> $log_file
validate $? "Starting and Enabling user service"
















