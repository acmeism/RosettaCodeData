import random, strutils, tables

type
  Choice {.pure.} = enum Rock, Paper, Scissors
  History = tuple[total: int; counts: CountTable[Choice]]

const Successor: array[Choice, Choice] = [Paper, Scissors, Rock]

func `>`(a, b: Choice): bool =
  ## By construction, only the successor is greater than the choice.
  a == Successor[b]

proc choose(history: History): Choice =
  ## Make a weighted random choice using the player counts
  ## then select the choice likely to beat it.
  var value = rand(1..history.total)
  for choice, count in history.counts.pairs:
    if value <= count:
      return Successor[choice]
    dec value, count


randomize()

# Initialize history with one for each choice in order to avoid special case.
var history: History = (3, [Rock, Paper, Scissors].toCountTable)

echo "To quit game, type 'q' when asked for your choice."

var myChoice, yourChoice: Choice
var myWins, yourWins = 0

while true:

  # Get player choice.
  try:
    stdout.write "Rock(1), paper(2), scissors(3). Your choice? "
    let answer = stdin.readLine().strip()
    if answer == "q":
      quit "Quitting game.", QuitSuccess
    if answer notin ["1", "2", "3"]:
      echo "Invalid choice."
      continue
    yourChoice = Choice(ord(answer[0]) - ord('1'))
  except EOFError:
    quit "Quitting game.", QuitFailure

  # Make my choice.
  myChoice = history.choose()
  echo "I choosed ", myChoice, '.'
  history.counts.inc yourChoice
  inc history.total

  # Display result of round.
  if myChoice == yourChoice:
    echo "It’s a tie."
  elif myChoice > yourChoice:
    echo "I win."
    inc myWins
  else:
    echo "You win."
    inc yourWins
  echo "Total wins. You: ", yourWins, "  Me: ", myWins
