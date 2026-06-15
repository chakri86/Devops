#!/bin/bash

ami_id='ami-0220d79f3f480ecf5'
zone_id='Z03373741NMWA7C0RATXM'
domine_name='avkc.online'

R="\e[31m" # Red color
G="\e[32m" # Green color
N="\e[0m"  # No color
Y="\e[33m" # Yellow color
time_stamnp=$(date "+%Y-%b-%d %H:%M:%S %Z")

###validation function
if [ $# -lt 2 ]; then
  echo  -e "$time_stamnp [ERROR] $R : atleast 2 arguments required $N" | tee -a $log_file
  echo "Usage: $0 [create|delete] [instance1] [instance2] ..." | tee -a $log_file
  exit 1
fi


action=$1
shift   # Remove the first argument so that $@ now contains only the instance names


if [ "$action" != "create" ] && [ "$action" != "delete" ]; then
    echo  -e "$time_stamnp [ERROR] $R : Invalid action specified. Use 'create' or 'delete'. $N" | tee -a $log_file
    echo "Usage: $0 [create|delete] [instance1] [instance2] ..." | tee -a $log_file
    exit 1
fi

get_instance_id() {
    name=$1
    aws ec2 describe-instances --filters "Name=tag:Name,Values=roboshop-$name" "Name=instance-state-name,Values=running" --query 
    "Reservations[0].Instances[0].InstanceId" --output text
}



for instance in $@
do
   insrance_id=$(get_instance_id $instance)
   if [ "$action" == "create" ]; then
       if [ "$insrance_id" == "None" ]; then
           echo -e "$time_stamnp [INFO] $G : Creating instance roboshop-$instance $N" | tee -a $log_file
           instance_id=$(aws ec2 run-instances \
           --image-id $ami_id \
           --instance-type t3.micro \
           --security-groups roboshop-common roboshop-$instance\
           --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
           --query 'Instances[0].InstanceId' \
           --output text
           )
           echo -e "$time_stamnp [INFO] $G : Instance roboshop-$instance created with ID: $instance_id $N" | tee -a $log_file
       else
           echo -e "$time_stamnp [INFO] $Y : Instance roboshop-$instance already exists with ID: $insrance_id $N" | tee -a $log_file
       fi
   fi
done