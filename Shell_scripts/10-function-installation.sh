#!/bin/bash

userid=$(id -u)

#chekc if the user is root or not
if [ $userid -eq 0 ]; then
    echo "you are root user, you can install the software"
else
    echo "you are not root user, you cannot install the software"
    exit 1
fi

validate(){
    if [ $2 -eq 0 ]; then
        echo "$1installed successfully"
    else
        echo "$1 installation failed"
        exit 1
    fi 
}

# myql installation

dnf list installed mysql

if [ $? -eq 0 ]; then
    echo "software is already installed"
else
    echo "software is not installed, installing the software..."
    dnf install mysql -y
    validate "mysql" $?
fi

# nginx installation

dnf list installed nginx

if [ $? -eq 0 ]; then
    echo "software is already installed"
else
    echo "software is not installed, installing the software..."
    dnf install nginx -y
    validate "nginx" $?
fi