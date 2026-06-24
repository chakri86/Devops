#!/bin/bash

source_dir=$1
dest_dir=$2
days=${3:-14}

if [ -z "$source_dir" ] || [ -z "$dest_dir" ]; then
    echo "either source directory or destination directory empty"
    echo "usage:: $0 [source_dir] [dest_dir] [days:deafult 14]"
    exit 1
fi

if [ ! -d "$source_dir" ]; then
    echo "source directory $source_dir doesn not exist"
    exit 1 
fi

if [ ! -d "$dest_dir" ]; then
    echo "destination directory $dest_dir doesn not exist"
    exit 1 
fi

files=$(find "$source_dir" -type f -name "*.log" -mtime +$days)


if [ -z "$files"]; then
    echo "log files older than 14 days not found, nothing to do"
    exit 0
fi

while IFS= read -r file
do
    echo "$file"
done <<< "files"