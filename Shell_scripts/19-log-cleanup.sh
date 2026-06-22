#!/bin/bash

source_dir=$1

days=${2:-14} # default 14days


if [ -z $source_dir ];then
    echo " Error: : missing paramaeter "
    echo "usage: $0 <source_dir> [days(optional deault to 14)]" 
    exit 1
fi


#checking directory empty or not 


if [ ! -d $source_dir]; then
    echo "error : directory : $source_dir does not exist"
    exit 1

fi

