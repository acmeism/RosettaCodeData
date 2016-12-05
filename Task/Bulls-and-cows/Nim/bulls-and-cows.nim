import random, strutils, rdstdin
randomize()

proc random(a: string): char = a[random(0..a.len)]

const
  digits = "123456789"
  size = 4

var digitsSet: set[char] = {}
for d in digits: digitsSet.incl d

var chosen = newString(size)
for i in 0..chosen.high: chosen[i] = random(digits)

echo """I have chosen a number from $# unique digits from 1 to 9 arranged in a random order.
You need to input a $# digit, unique digit number as a guess at what I have chosen""".format(size, size)

var guesses = 0
while true:
  inc guesses
  var guess = ""
  while true:
    guess = readLineFromStdin("\nNext guess [$#]: ".format(guesses)).strip()
    if guess.len == size and allCharsInSet(guess, digitsSet):
      break
    echo "Problem, try again. You need to enter $# unique digits from 1 to 9".format(size)
  if guess == chosen:
    echo "\nCongratulations you guessed correctly in ",guesses," attempts"
    break
  var bulls, cows = 0
  for i in 0 .. <size:
    if guess[i] == chosen[i]: inc bulls
    if guess[i] in chosen: inc cows
  echo "  $# Bulls\n  $# Cows".format(bulls, cows)
