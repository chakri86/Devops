
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


dnf install maven -y &>> $log_file
validate $? "Installing Maven"

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

rm -rf /tmp/shipping.zip &>> $log_file
validate $? "Removing existing application archive if it exists"

curl -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping-v3.zip  &>> $log_file
cd /app 
unzip /tmp/shipping.zip &>> $log_file
validate $? "Extracting shipping application code"

mvn clean package &>> $log_file
validate $? "Installing shipping application dependencies"

cp $script_directory/shipping.service /etc/systemd/system/shipping.service &>> $log_file
validate $? "Copying shipping systemd service file"

dnf install mysql -y &>> $log_file
validate $? "Installing MySQL client"

mysql -h $MYSQL_HOST -u root -pRoboShop@1 -e "use cities" &>>$LOGS_FILE
if [ $? -ne 0 ]; then
  mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql
  mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql
  mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql
  VALIDATE $? "$time_stamnp [INFO] ${G} Data loaded successfully.${N}" | tee -a $log_file
else
  echo -e "$time_stamnp [INFO] ${Y} Data already loaded ... SKIPPING $N" | tee -a $log_file
fi



systemctl enable shipping   &>> $log_file 
systemctl restart shipping  &>> $log_file
validate $? "Starting and Enabling shipping service"


