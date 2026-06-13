#!/bin/bash

userid=$(id -u)
logs_dir=/home/ec2-user/logs  # log file directory



log_file="$logs_dir/$0.log"



#chekc if the user is root or not
if [ $userid -eq 0 ]; then
    echo "you are root user, you can install the software"
else
    echo "you are not root user, you cannot install the software"
    exit 1
fi

#we keept his repeated code in a function and we will call the function whenever we need to validate the installation of the software
validate(){
    if [ $2 -eq 0 ]; then
        echo "$1installed successfully"
    else
        echo "$1 installation failed"
        exit 1
    fi 
}

# myql installation

dnf list installed mysql &>> $log_file

if [ $? -eq 0 ]; then
    echo "software is already installed"
else
    echo "software is not installed, installing the software..."
    dnf install mysql -y &>> $log_file
    validate "mysql" $?
fi

# nginx installation

dnf list installed nginx &>> $log_file

if [ $? -eq 0 ]; then
    echo "software is already installed"
else
    echo "software is not installed, installing the software..."
    dnf install nginx -y &>> $log_file
    validate "nginx" $?
fi