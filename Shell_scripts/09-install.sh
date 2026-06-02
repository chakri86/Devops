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

echo "installing the software..."
dnf install mysqlweer -y

if [ $? -eq 0 ]; then
    echo "software installed successfully"
else
    echo "software installation failed"
fi