#!/bin/bash

disk_usage=$(df -hT | grep -v Filesystem)
usage_thrashold=10

while IFS= read -r line
do
    usage=$( echo $line | awk '{print $6}' | cut -d "%" -f1)
    partition=$(echo $line | awk '{print $7}')
    if [ "$usage" -ge "$usage_thrashold"]; then
        message="high disk usage on $partition : $usage"
    fi
done <<< "$disk_usage"

echo "$message"