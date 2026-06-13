#!/bin/bash

userid=$(id -u)

#chekc if the user is root or not
if [ $userid -eq 0 ]; then
    echo "you are root user, you can install the software"
else
    echo "you are not root user, you cannot install the software"
    exit 1
fi



echo "iam continuing with the rest of the script"

dnf list installed mysql

if [ $? -eq 0 ]; then
    echo "software is already installed"
    exit 0
else
    echo "software is not installed, installing the software..."
    echo "installing the software..."
    dnf install mysql -y

    if [ $? -eq 0 ]; then
        echo "software installed successfully"
    else
        echo "software installation failed"
        exit 1
    fi    
fi

dnf list installed nginx

if [ $? -eq 0 ]; then
    echo "software is already installed"
    exit 0
else
    echo "software is not installed, installing the software..."
    echo "installing the software..."
    dnf install mysql -y

    if [ $? -eq 0 ]; then
        echo "software installed successfully"
    else
        echo "software installation failed"
        exit 1
    fi    
fi