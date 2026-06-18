#!/bin/bash

while IFS= read -r line # if internal filed seperator
do
    echo "$line"

done < 01-helloworld.sh