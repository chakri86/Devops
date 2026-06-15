#!/bin/bash

ami_id= 'ami-0220d79f3f480ecf5'
zone_id='Z03373741NMWA7C0RATXM'
domine_name='avkc.online'

R="\e[31m" # Red color
G="\e[32m" # Green color
N="\e[0m"  # No color
Y="\e[33m" # Yellow color
time_stamnp=$(date "+%Y-%b-%d %H:%M:%S %Z")

###validation function
if [ $# -lt 2 ]; then
  echo  -e"$time_stamnp [ERROR] ${R} : atleast 2 arguments required ${N}" | tee -a $log_file
  echo "Usage: $0 [create|delete] [instance1] [instance2] ..." | tee -a $log_file
  exit 1
fi


