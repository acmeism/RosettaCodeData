import random, strutils, strformat, sequtils
randomize()

const
  Digits = "123456789"
  DigitSet = {Digits[0]..Digits[^1]}
  Size = 4

proc sample(s: string; n: Positive): string =
  ## Return a random sample of "n" characters extracted from string "s".
  var s = s
  s.shuffle()
  result = s[0..<n]

proc plural(n: int): string =
  if n > 1: "s" else: ""

let chosen = Digits.sample(Size)

echo &"I have chosen a number from {Size} unique digits from 1 to 9 arranged in a random order."
echo &"You need to input a {Size} digit, unique digit number as a guess at what I have chosen."

var guesses = 0
while true:
  inc guesses
  var guess = ""
  while true:
    stdout.write(&"\nNext guess {guesses}: ")
    guess = stdin.readLine().strip()
    if guess.len == Size and allCharsInSet(guess, DigitSet) and guess.deduplicate.len == Size:
      break
    echo &"Problem, try again. You need to enter {Size} unique digits from 1 to 9."
  if guess == chosen:
    echo &"\nCongratulations! You guessed correctly in {guesses} attempts."
    break
  var bulls, cows = 0
  for i in 0..<Size:
    if guess[i] == chosen[i]: inc bulls
    elif guess[i] in chosen: inc cows
  echo &"  {bulls} Bull{plural(bulls)}\n  {cows} Cow{plural(cows)}"
