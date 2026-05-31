#!/bin/bash

# timestamp=$(date)

# echo "current timestamp: $timestamp"

# timestamp1=$(date +"%Y-%m-%d %H:%M:%S")
# echo "current timestamp in custom format: $timestamp1"

star_timestamp=$(date +"%Y-%m-%d %H:%M:%S")


sleep 10


endtimestamp=$(date +"%Y-%m-%d %H:%M:%S")

total_time=$(date -d "$endtimestamp" +%s) - $(date -d "$star_timestamp" +%s)
echo "total time taken: $total_time seconds"
