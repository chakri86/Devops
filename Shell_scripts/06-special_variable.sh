#!/bin/bash

##special variables

echo " all variables: passe to the scipts  $@"
echo " total number of variables passed to the script: $#"
echo " name of the script: $0"
echo " first variable: $1"
echo " second variable: $2"
echo " who is runnuing the script: $USER"
echo " home directory of the user: $HOME"
echo " current working directory: $PWD"
echo " exit status of the last command: $?"
echo " process id of the current script: $$"
echo " last background process id: $!"
echo " all variables as a single string: $*"
echo " all variables as a single string with double quotes: \"$*\""
echo " all variables as a single string with double quotes and space: \"$@\""