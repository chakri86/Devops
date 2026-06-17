
#!/bin/bash

source ./common.sh

check_root


cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo  
validate $? "Copying RabbitMQ repo file"

dnf install rabbitmq-server -y &>> $log_file
validate $? "Installing RabbitMQ Server"


systemctl enable rabbitmq-server 
systemctl start rabbitmq-server
validate $? "Starting and Enabling RabbitMQ service"

rabbitmqctl add_user roboshop roboshop123 &>> $log_file
validate $? "Creating RabbitMQ user"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $log_file
validate $? "Setting RabbitMQ user permissions"

print_total_time