import parseutils
import random
import sequtils
import strformat
import strutils

const
  Digits = "123456789"
  DigitSet = {Digits[0]..Digits[^1]}
  Size = 4
  InvalidScore = -1

type

  Digit = range['1'..'9']
  Score = tuple[bulls, cows: int]
  HistItem = tuple[guess: string, bulls, cows: int]

#---------------------------------------------------------------------------------------------------

proc buildChoices(digits: set[Digit]; size: Natural): seq[string] =
  ## Build the list of choices when starting the game.

  if size == 0:
    return @[""]
  for d in digits:
    for s in buildChoices(digits - {d}, size - 1):
      result.add(d & s)

#---------------------------------------------------------------------------------------------------

proc getValues(): Score =
  ## Read the number of bulls and cows provided by the user.

  let input = stdin.readLine().strip()
  let fields = input.splitWhitespace()
  if fields.len != 2 or
     fields[0].parseInt(result.bulls, 0) == 0 or result.bulls notin 0..Size or
     fields[1].parseInt(result.cows, 0) == 0 or result.cows notin 0..Size:
    echo &"Wrong input; expected two number between 0 and {Size}"
    return (InvalidScore, InvalidScore)
  if result.bulls + result.cows > Size:
    echo &"Total number of bulls and cows exceeds {Size}"
    return (InvalidScore, InvalidScore)

#---------------------------------------------------------------------------------------------------

func score(value, guess: string): Score =
  ## Return the score of "guess" against "value".

  for idx, digit in guess:
    if digit == value[idx]:
      inc result.bulls
    elif digit in value:
      inc result.cows

#---------------------------------------------------------------------------------------------------

proc findError(history: seq[HistItem]) =
  ## Find the scoring error.

  var value: string

  ## Get the number to find.
  while true:
    stdout.write("What was the number to find? ")
    value = stdin.readLine().strip()
    if value.len == Size and allCharsInSet(value, DigitSet) and value.deduplicate.len == Size:
      break

  # Find inconsistencies.
  for (guess, userbulls, usercows) in history:
    let (bulls, cows) = score(guess, value)
    if userbulls != bulls or usercows != cows:
      echo &"For guess {guess}, score was wrong:"
      echo &"  Expected {bulls} / {cows}, got {userBulls} / {userCows}."

#---------------------------------------------------------------------------------------------------

func suffix(n: Positive): string =
  ## Return the suffix for an ordinal.

  case n
  of 1: "st"
  of 2: "nd"
  of 3: "rd"
  else: "th"

#---------------------------------------------------------------------------------------------------

var history: seq[HistItem]

randomize()

var choices = buildChoices(DigitSet, Size)
choices.shuffle()

echo "Choose a number with four unique digits between 1 and 9."
echo "Give the number of bulls and cows separated by one or more spaces."

var guesses = 0
var remaining: seq[string]

while true:
  inc guesses
  var userbulls, usercows: int
  let guess = choices.pop()
  echo &"My {guesses}{suffix(guesses)} guess is {guess}"

  # Get scoring.
  while true:
    stdout.write("How many bulls and cows? ")
    (userbulls, usercows) = getValues()
    if userbulls != InvalidScore and usercows != InvalidScore:
      break

  if userbulls == Size:
      echo &"Victory! I found the number in {guesses} attempts."
      break

  history.add((guess, userbulls, usercows))

  # Eliminate incompatible choices.
  remaining.setLen(0)
  for choice in choices:
    let (bulls, cows) = score(guess, choice)
    if bulls == userbulls and cows == usercows:
      remaining.add(choice)
  if remaining.len == 0:
    echo &"There is an impossibility. For some guess you made an error in scoring."
    history.findError()
    break
  choices = move(remaining)
