#!/bin/bash

var1= $1
var2= $2

echo "var1: $var1"
echo "var2: $var2"

echo "var1: ${var1}"
echo "var2: ${var2}"

echo "var1: ${var1:-default_value}"
echo "var2: ${var2:-default_value}"

echo "hi $var1, how are you?"
echo "hi $var2, how are you?"


