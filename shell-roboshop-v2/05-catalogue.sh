
#!/bin/bash

app_name=catalogue
source ./common.sh

check_root 


app_setup

nodejs_setup

systemd_setup


rm -rf /etc/yum.repos.d/mongo.repo &>> $log_file
validate $? "Removing existing MongoDB repo file if it exists"

cp $script_directory/mongo.repo /etc/yum.repos.d/mongo.repo &>> $log_file
validate $? "Copying MongoDB repo file"

dnf install mongodb-mongosh -y &>> $log_file
validate $? "Installing MongoDB client"

index=$(mongosh --host mongodb.avkc.online --eval 'db.getMongo().getDBNames().indexOf("catalouge")')

if [ $index -lt 0 ]; then
  mongosh --host mongodb.avkc.online </app/db/master-data.js &>> $log_file
  validate $? "load catalogue database and collection with initial data"
 else
  echo -e "$time_stamnp [INFO] ${Y} MongoDB user and database for catalogue already exists, skipping creation.${N}" | tee -a $log_file
fi

app_restart

print_total_time














