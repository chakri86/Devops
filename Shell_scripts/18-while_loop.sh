#!/bin/bash

while IFS= read -r line # if internal filed seperator
do
    echo "$line"

done < 02-conversation.sh