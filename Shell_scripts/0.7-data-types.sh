#!/bin/bash
num1=10
num2=chakri
sum=$((num1 + num2))

echo "sum: $sum"

movies=("movie1" "movie2" "movie3")
echo "movies: ${movies[@]}"
echo "first movie: ${movies[0]}"
echo "second movie: ${movies[1]}"
echo "third movie: ${movies[2]}"