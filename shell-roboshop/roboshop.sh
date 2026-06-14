#!/bin/bash

ami_id= 'ami-0220d79f3f480ecf5'
zone_id='Z03373741NMWA7C0RATXM'
domine_name='avkc.online'

for instance in $@
do
    echo "Creating EC2 instance for $instance"
    Instance_id=$(aws ec2 run-instances \
        --image-id ami-0220d79f3f480ecf5 \
        --instance-type t3.micro \
        --security-groups roboshop-common\
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )
    echo "Instance $instance created with ID: $Instance_id"

    if [ "$instance" == "frontend" ]; then
        IP=$(aws ec2 describe-instances \
        --instance-ids $Instance_id \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text
        )
        R53_Record="$domine_name"
    else
        IP=$(aws ec2 describe-instances \
        --instance-ids $Instance_id \
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
    
done