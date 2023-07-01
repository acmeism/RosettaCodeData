# 21 game.

import random
import strformat
import strutils

const
  Target = 21
  PossibleChoices: array[18..20, seq[string]] = [@["1", "2", "3"], @["1", "2"], @["1"]]
  Targets = [1, 5, 9, 13, 17, 21]     # Totals that a player must obtain to win.

#---------------------------------------------------------------------------------------------------

proc printTotal(total: int) =
  ## Print the running total.
  echo fmt"Running total is now {total}."

#---------------------------------------------------------------------------------------------------

proc computerPlays(total: var int) =
  ## Make the computer play.
  var choice: int
  if total in Targets:
    # No winning choice. Choose a random value.
    choice = rand(1..3)
  else:
    # Find the running total to get.
    for val in Targets:
      if val > total:
        choice = val - total
        break
  inc total, choice
  echo fmt"I choose {choice}."
  printTotal(total)

#---------------------------------------------------------------------------------------------------

proc prompt(message: string; answers: openArray[string]): int =
  ## Prompt a message and get an answer checking its validity against possible answers.

  while true:
    stdout.write(message & ' ')
    try:
      result = answers.find(stdin.readLine())
      if result >= 0:
        break
      echo fmt"Please answer one of: {answers.join("", "")}."
    except EOFError:
      echo ""
      return  # Quit.

#---------------------------------------------------------------------------------------------------

randomize()

echo "21 is a two player game. The game is played by choosing a number (1, 2, 3) to\n" &
     "be added to the running total. The game is won by the player whose chosen number\n" &
     "causes the running total to reach exactly 21. The running total starts at zero.\n"
echo "You can quit the game at any time by typing 'q'."

block mainLoop:

  while true:
    var total = 0

    # Choose the player who will play first.
    var answer = prompt("Who will play first ('you', 'me')?", ["q", "you", "me"])
    if answer == 0:
      echo "Quitting game."
      break
    elif answer == 1:
      computerPlays(total)

    # Internal game loop.
    while true:

      # Ask player its choice.
      let choices = if total > 18: PossibleChoices[total] else: PossibleChoices[18]
      let choice = prompt(fmt"Your choice ({choices.join("", "")})?", "q" & choices)
      if choice == 0:
        echo "Quitting game."
        break mainLoop

      # Update running total and check if player win.
      inc total, choice
      printTotal(total)
      if total == Target:
        echo "Congratulations, you win."
        break

      # Make computer play.
      computerPlays(total)
      if total == Target:
        echo "Sorry, I win."
        break

    # Ask player for another game.
    answer = prompt("Do you want to play another game (y, n)", ["q", "y", "n"])
    if answer != 1:
      echo "Quitting game."
      break
