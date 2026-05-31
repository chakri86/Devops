#!/bin/bash

# timestamp=$(date)

# echo "current timestamp: $timestamp"

# timestamp1=$(date +"%Y-%m-%d %H:%M:%S")
# echo "current timestamp in custom format: $timestamp1"

star_timestamp=$(date +%s)


sleep 10


endtimestamp=$(date +%s)

total_time=$((endtimestamp - star_timestamp))   

echo "total time taken: $total_time seconds"
