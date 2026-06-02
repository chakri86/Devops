#!/bin/bash
num1=10
num2=chakri
num3=20


echo "num1: $num1"
echo "num2: $num2"
echo "num3: $num3"

sum1=$((num1 + num3))
sum2=$((num1 + num2))
sum3=$((num1+ num2 + num3))
echo "sum1: $sum1"
echo "sum2: $sum2"
echo "sum3: $sum3"

movies=("movie1" "movie2" "movie3")
echo "movies: ${movies[@]}"
echo "first movie: ${movies[0]}"
echo "second movie: ${movies[1]}"
echo "third movie: ${movies[2]}"