import random, strformat, strutils

randomize()

stdout.write "Player 1 - Enter your name : "
let name1 = block:
              let n = stdin.readLine().strip()
              if n.len == 0: "PLAYER 1" else: n.toUpper
stdout.write "Player 2 - Enter your name : "
let name2 = block:
              let n = stdin.readLine().strip()
              if n.len == 0: "PLAYER 2" else: n.toUpper

let names = [name1, name2]
var totals: array[2, Natural]
var player = 0

while true:
  echo &"\n{names[player]}"
  echo &"  Your total score is currently {totals[player]}"
  var score = 0

  while true:
    stdout.write "  Roll or Hold r/h : "
    let rh = stdin.readLine().toLowerAscii()
    case rh

    of "h":
      inc totals[player], score
      echo &"  Your total score is now {totals[player]}"
      if totals[player] >= 100:
        echo &"  So, {names[player]}, YOU'VE WON!"
        quit QuitSuccess
      player = 1 - player
      break

    of "r":
      let dice = rand(1..6)
      echo &"    You have thrown a {dice}"
      if dice == 1:
        echo "    Sorry, your score for this round is now 0"
        echo &"  Your total score remains at {totals[player]}"
        player = 1 - player
        break
      inc score, dice
      echo &"    Your score for the round is now {score}"

    else:
      echo "    Must be 'r' or 'h', try again"
