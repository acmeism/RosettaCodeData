import std/[strformat, strutils]

type Color {.pure.} = enum Grey = "grey", Yellow = "yellow", Green = "green"

proc wordle(answer, guess: string): seq[Color] =
  let n = guess.len
  if answer.len != n:
    quit "The words must be of the same length.", QuitFailure
  var answer = answer
  result.setLen(n)
  for i in 0..<n:
    if guess[i] == answer[i]:
      answer[i] = '\0'
      result[i] = Green
  for i in 0..<n:
    let ix = answer.find(guess[i])
    if ix >= 0:
      answer[ix] = '\0'
      result[i] = Yellow

const Pairs = [["ALLOW", "LOLLY"],
               ["BULLY", "LOLLY"],
               ["ROBIN", "ALERT"],
               ["ROBIN", "SONIC"],
               ["ROBIN", "ROBIN"]]

for pair in Pairs:
  let res  = wordle(pair[0], pair[1])
  echo &"""{pair[0]} v {pair[1]} → ({res.join(", ")})"""
