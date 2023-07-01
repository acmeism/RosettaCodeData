import strutils
import terminal

var tokens = 12

styledEcho(styleBright, "Nim in Nim\n")

proc echoTokens() =
  styledEcho(styleBright, "Tokens remaining: ", resetStyle, $tokens, "\n")

proc player() =
  var take = '0'
  styledEcho(styleBright, "- Your turn -")
  echo "How many tokens will you take?"
  while true:
    stdout.styledWrite(styleDim, "Take (1–3): ", resetStyle)
    take = getch()
    stdout.write(take, '\n')
    if take in {'1'..'3'}:
      tokens -= parseInt($take)
      break
    else:
      echo "Please choose a number between 1 and 3."
  echoTokens()

proc computer() =
  styledEcho(styleBright, "- Computer's turn -")
  let take = tokens mod 4
  tokens -= take
  styledEcho("Computer took ", styleBright, $take, " ",
             if take == 1: "token"
             else: "tokens")
  echoTokens()

while tokens > 0:
  player()
  computer()

styledEcho(styleBright, "Computer wins!")
