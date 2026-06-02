#!/bin/bash
number=$1

#gt - greater than
#lt - less than
#eq - equal to 
#ne - not equal to
#ge - greater than or equal to
#le - less than or equal to



if [ $number -gt 10 ]; then
    echo "$number is greater than 10"
elif [ $number -lt 10 ]; then
    echo "$number is less than 10"
else
    echo "$number is equal to 10"
fi