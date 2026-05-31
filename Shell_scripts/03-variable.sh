#!/bin/bash

echo "please enter your name:"
read username

echo "hello $username, welcome to shell scripting!"

echo "please enter your password:"
read -s password
echo "your password is: $password"
