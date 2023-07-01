import random, sequtils, strformat, strutils

proc encode(correct, guess: string): string =
  result.setlen(correct.len)
  for i in 0..correct.high:
    result[i] = if correct[i] == guess[i]: 'X' else: (if guess[i] in correct: 'O' else: '-')
  result.join(" ")

proc safeIntInput(prompt: string; minVal, maxVal: Positive): int =
  while true:
    stdout.write prompt
    let userInput = stdin.readLine()
    result = try: parseInt(userInput)
             except ValueError: continue
    if result in minVal..maxVal:
      return


proc playGame() =

  echo "You will need to guess a random code."
  echo "For each guess, you will receive a hint."
  echo "In this hint, X denotes a correct letter, " &
       "and O a letter in the original string but in a different position."
  echo ""

  let numLetters = safeIntInput("Select a number of possible letters for the code (2-20): ", 2, 20)
  let codeLength = safeIntInput("Select a length for the code (4-10): ", 4, 10)
  let letters = "ABCDEFGHIJKLMNOPQRST"[0..<numLetters]
  let code = newSeqWith(codeLength, letters.sample()).join()
  var guesses: seq[string]

  while true:
    echo ""
    stdout.write &"Enter a guess of length {codeLength} ({letters}): "
    let guess = stdin.readLine().toUpperAscii().strip()
    if guess.len != codeLength or guess.anyIt(it notin letters):
      continue
    elif guess == code:
      echo &"\nYour guess {guess} was correct!"
      break
    else:
      guesses.add &"{guesses.len + 1}: {guess.join(\" \")} => {encode(code, guess)}"
    for guess in guesses:
      echo "------------------------------------"
      echo guess
    echo "------------------------------------"


randomize()
playGame()
