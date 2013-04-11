#!/bin/sh
# Guess the number
# This simplified program does not check the input is valid

# Use awk(1) to get a random number. If awk(1) not found, exit now.
number=`awk 'BEGIN{print int(rand()*10+1)}'` || exit

echo 'I have thought of a number. Try to guess it!'
echo 'Enter an integer from 1 to 10.'
until read guess; [ "$guess" -eq "$number" ]
do
  echo 'Sorry, the guess was wrong! Try again!'
done
echo 'Well done! You guessed it.'
