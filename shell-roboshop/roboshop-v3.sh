#!/bin/bash

ami_id="ami-0220d79f3f480ecf5"
zone_id="Z03373741NMWA7C0RATXM"
domine_name="avkc.online"

R="\e[31m" # Red color
G="\e[32m" # Green color
N="\e[0m"  # No color
Y="\e[33m" # Yellow color
time_stamnp=$(date "+%Y-%b-%d %H:%M:%S %Z")

all_instances="mongodb redis mysql rabbitmq user cart catalogue shipping payment frontend"


###validation function
if [ $# -lt 2 ]; then
  echo  -e "$time_stamnp [ERROR] $R : atleast 2 arguments required $N" 
  echo "Usage: $0 [create|delete] [instance1] [instance2] ..." 
  exit 1
fi


action=$1
shift   # Remove the first argument so that $@ now contains only the instance names


if [ "$action" != "create" ] && [ "$action" != "delete" ]; then
    echo  -e "$time_stamnp [ERROR] $R : Invalid action specified. Use 'create' or 'delete'. $N" 
    echo "Usage: $0 [create|delete] [instance1] [instance2] ..." 
    exit 1
fi

# if all arguments are valid, then proceed with the script execution

if [ "$1" == "all" ]; then 
    if [ "$action" == "create" ]; then
        instances= "all_instances"
            
    else
        instnaces=$(echo $all_instances | tr ' ' '\n' | tac | tr '\n' ' ')
    fi
else
    instances="$@"
fi    


get_instance_id() {
    name=$1
    aws ec2 describe-instances --filters "Name=tag:Name,Values=roboshop-$name" "Name=instance-state-name,Values=running" --query "Reservations[0].Instances[0].InstanceId" --output text
}

for instance in $@
do
   instance_id=$(get_instance_id $instance)
   if [ $action == "create" ]; then
       if [ $instance_id == "None" ]; then
           echo -e "$time_stamnp [INFO] $G : Creating instance roboshop-$instance $N"
           instance_id=$( aws ec2 run-instances \
            --image-id $ami_id \
            --instance-type t3.micro \
            --security-groups "roboshop-common" "roboshop-$instance" \
            --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
            --query 'Instances[0].InstanceId' \
            --output text
            )

            echo -e "$time_stamnp [INFO] $G : Instance roboshop-$instance with ID: $instance_id $N" 

           
       else
            echo -e "$time_stamnp [INFO] $Y : Instance roboshop-$instance already exists with ID: $instance_id $N" 
            
       fi

        ##update route53

        if [ "$instance" == "frontend" ]; then
            IP=$(aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[*].Instances[*].PublicIpAddress' \
            --output text
            )
            R53_Record="$domine_name"
        else
            IP=$(aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[*].Instances[*].PrivateIpAddress' \
            --output text
            )  
            R53_Record="$instance.$domine_name"  
        fi

        ## updating Route53 record
        aws route53 change-resource-record-sets \
        --hosted-zone-id $zone_id \
        --change-batch '
            {
                "Comment": "Updating record for new IP address",
                "Changes": [
                    {
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                            "Name": "'$R53_Record'",
                            "Type": "A",
                            "TTL": 1,
                            "ResourceRecords": [
                                {
                                    "Value": "'$IP'"
                                }
                            ]
                        }
                    }
                ]
            }
        '
        echo -e "$time_stamnp [INFO] $G : Route53 record $R53_Record updated with IP: $IP $N"
   else
         if [ $instance_id != "None" ]; then
              echo -e "$time_stamnp [INFO] $G : Deleting instance roboshop-$instance with ID: $instance_id $N"
              aws ec2 terminate-instances --instance-ids $instance_id
              echo -e "$time_stamnp [INFO] $G : Instance roboshop-$instance with ID: $instance_id terminated $N"
         else
              echo -e "$time_stamnp [INFO] $Y : Instance roboshop-$instance does not exist, skipping deletion. $N"
         fi
   fi
done

