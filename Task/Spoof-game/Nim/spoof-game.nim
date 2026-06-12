import math, random, sequtils, strformat, strutils, terminal

const Test = true

proc getNumber(prompt: string; min, max: int; showMinMax: bool): int =
  while true:
    stdout.write prompt
    stdout.write if showMinMax: &" from {min} to {max}: " else: ": "
    stdout.flushFile()
    try:
      result = stdin.readLine().parseInt()
    except ValueError:
      echo "Wrong input"
      continue
    except EOFError:
      quit "\nEnd of file encountered. Quitting", QuitFailure
    if result in min..max: break
    echo "Value out of range"
  echo()


proc play() =
  let
    players = getNumber("Number of players", 2, 9, true)
    coins = getNumber("Number of coins per player", 3, 6, true)
  var
    remaining = toSeq(1..players)
    first = rand(1..players)
    round = 1

  echo "The number of coins in your hand will be randomly determined for"
  echo "each round and displayed to you. However, when you press ENTER"
  echo "it will be erased so that the other players, who should look"
  echo "away until it's their turn, won't see it. When asked to guess"
  echo "the total, the computer won't allow a 'bum guess'."

  while true:
    echo &"\nROUND {round:}\n"
    var
      n = first
      hands = newSeq[int](players + 1)
      guesses = repeat(- 1, players + 1)
    while true:
      echo &"  PLAYER {n}:"
      echo "    Please come to the computer and press ENTER"
      hands[n] = rand(coins)
      let plural = if hands[n] > 1: "s" else: ""
      stdout.write &"      <There are {hands[n]} coin{plural} in your hand>"
      discard stdin.readLine()
      if not Test:
        cursorUp()
        eraseLine()
        stdout.write '\r'
      else:
        echo()
      while true:
        let min = hands[n]
        let max = remaining.high * coins + hands[n]
        let guess = getNumber("    Guess the total", min, max, false)
        if guess notin guesses:
            guesses[n] = guess
            break
        echo "    Already guessed by another player, try again"
      let index = remaining.find(n)
      n = remaining[(index + 1) mod remaining.len]
      if n == first: break

    let total = sum(hands)
    echo "  Total coins held = ", total
    var eliminated = false
    for i, n in remaining:
      if guesses[n] == total:
        echo &"  PLAYER {n} guessed correctly and is eliminated"
        remaining.delete(i)
        eliminated = true
        break

    if not eliminated:
      echo "  No player guessed correctly in this round"
    else:
      if remaining.len == 1:
        echo &"\nPLAYER {remaining[0]} buys the drinks!"
        return

    let index = remaining.find(n)
    first = remaining[(index + 1) mod remaining.len]
    inc round


randomize()
play()
