import random, sequtils, strformat, tables

const Snl = {4: 14, 9: 31, 17: 7, 20: 38, 28: 84, 40: 59, 51: 67, 54: 34,
             62: 19, 63: 81, 64: 60, 71: 91, 87: 24, 93: 73, 95: 75, 99: 78}.toTable

const SixThrowsAgain = true


proc turn(player, square: Positive): int =
  var square = square
  while true:
    let roll = rand(1..6)
    stdout.write &"Player {player}, on square {square}, rolls a {roll}"
    if square + roll > 100:
      echo " but cannot move."
    else:
      inc square, roll
      echo &" and moves to square {square}."
      if square == 100: return 100
      let next = Snl.getOrDefault(square, square)
      if square < next:
        echo &"Yay! Landed on a ladder. Climb up to {next}."
        if next == 100: return 100
        square = next
      elif square > next:
        echo &"Oops! Landed on a snake. Slither down to {next}."
        square = next
    if roll < 6 or not SixThrowsAgain: return square
    echo "Rolled a 6 so roll again."


proc playGame(n: Positive) =

    # "n" players starting on square one.
    var players = repeat(1, n)
    while true:
      for i, s in players:
        let ns = turn(i + 1, s)
        if ns == 100:
          echo &"Player {i+1} wins!"
          return
        players[i] = ns
        echo()

randomize()

when isMainModule:
  playGame(3)
