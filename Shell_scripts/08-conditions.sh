#!/bin/bash
number=$1


if [$number -gt 5 ]; then
    echo "number is greater than 5"
elif [$number -lt 10 ]; then
    echo "number is less than 10"
elif [$number -lt 5 ]; then
    echo "number is less than 5"
else
    echo "number is equal to 5"
fi