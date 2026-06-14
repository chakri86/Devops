#!/bin/bash

userid=$(id -u)
logs_dir=/home/ec2-user/logs  # log file directory

log_file="$logs_dir/$0.log"

time_stamp=$(date "+%Y-%b-%d %H:%M:%S %Z") # we are getting the current date and time and storing it in a variable

R="\e[31m" # red color
G="\e[32m" # green color
P="\e[35m" # purple color
B="\e[34m" # blue color
Y="\e[33m" # yellow color
C="\e[36m" # cyan color
N="\e[0m"  # no color

trap 'echo "error occurred at line $LINENO while executing: $BASH_COMMAND $N"' ERR

#chekc if the user is root or not
if [ $userid -eq 0 ]; then
    echo "$time_stamp [INFO] you are root user, you can install the software"
else
    echo -e "$time_stamp [ERROR] you are not root user, you $R cannot install the software $N"
    exit 1
fi


for package in $@
do 
    echo "$time_stamp [INFO] installing $package "
    dnf list installed $package &>> $log_file # we are redirecting the output of this command to the log file
    if [ $? -eq 0 ]; then
        echo "$time_stamp [INFO] $package is already installed" | tee -a $log_file # we are redirecting the output of this command to the log file
    else
        echo -e "$time_stamp software is $C not installed $N, installing the software..."
        dnf install $package -y &>> $log_file # we are redirecting the output of this command to the log file
        
    fi
done