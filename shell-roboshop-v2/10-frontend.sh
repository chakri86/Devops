
#!/bin/bash


app_name=frontend
source ./common.sh

check_root 

ngnix_setup

rm -rf /usr/share/nginx/html/* 
validate $? "Removing default Nginx content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $log_file
validate $? "Downloading frontend application code"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> $log_file
validate $? "Extracting frontend application code"

rm -rf /etc/nginx/nginx.conf &>> $log_file
validate $? "Removing default Nginx configuration file" 

cp $script_directory/nginx.conf /etc/nginx/nginx.conf &>> $log_file
validate $? "Copying custom Nginx configuration file"

systemctl enable nginx &>> $log_file

systemctl restart nginx &>> $log_file
validate $? "Restarting Nginx service"

print_total_time





