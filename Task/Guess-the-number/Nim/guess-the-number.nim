import strutils, random

randomize()
var chosen = rand(1..10)
echo "I have thought of a number. Try to guess it!"

var guess = parseInt(readLine(stdin))

while guess != chosen:
  echo "Your guess was wrong. Try again!"
  guess = parseInt(readLine(stdin))

echo "Well guessed!"
