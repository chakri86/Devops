#!/bin/bash
number=$1

#gt - greater than
#lt - less than
#eq - equal to 
#ne - not equal to
#ge - greater than or equal to
#le - less than or equal to



if [$number -gt 5 ]; then
    echo "number is greater than 5"
elif [$number -lt 5 ]; then
    echo "number is less than 5"
else
    echo "number is equal to 5"
fi