#!/bin/bash

source_dir=$1

days=${2:-14} # default 14days


if [ -z $source_dir ];then
    echo " Error: : missing paramaeter "
    echo "usage: $0 <source_dir> [days(optional deault to 14)]" 
    exit 1
fi


#checking directory empty or not 


if [ ! -d $source_dir]; then
    echo "error : directory : $source_dir does not exist"
    exit 1

fi

echo "scanning $source_dir for log files older than 14  days"

files_to_be=$(find $source_dir -name  "*.log" -type f -mtime +$days)

if [ -z $files_to_be ]; then
    echo " no logs files older than 14 days found"
    exit 0
fi

while IFS= read -r file
do 
    echo "file to be deleted : $files_to_be"
done <<< "$files_to_be"