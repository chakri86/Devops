#!/bin/bash

userid=$(id -u)
logs_dir=/home/ec2-user/logs  # log file directory

log_file="$logs_dir/$0.log"

time_stamp=$(date "+%Y-%b-%d %H:%M:%S %Z") # we are getting the current date and time and storing it in a variable



#chekc if the user is root or not
if [ $userid -eq 0 ]; then
    echo "$time_stamp [INFO] you are root user, you can install the software"
else
    echo "$time_stamp [ERROR] you are not root user, you cannot install the software"
    exit 1
fi

#we keept his repeated code in a function and we will call the function whenever we need to validate the installation of the software
validate(){
    if [ $2 -eq 0 ]; then
        echo "$time_stamp [SUCCESS] $1 installed successfully" | tee -a $log_file # we are redirecting the output of this command to the log file
    else
        echo "$time_stamp [ERROR] $1 installation failed" | tee -a $log_file # we are redirecting the output of this command to the log file
        exit 1
    fi 
}

for package in $@
do 
    #echo " installing $package "
    dnf list installed $package &>> $log_file # we are redirecting the output of this command to the log file
    if [ $? -eq 0 ]; then
        echo "$time_stamp [INFO] software is already installed" | tee -a $log_file # we are redirecting the output of this command to the log file
    else
        echo "$time_stamp software is not installed, installing the software..."
        dnf install $package -y &>> $log_file # we are redirecting the output of this command to the log file
        validate "Installing $package" $?
    fi
done

