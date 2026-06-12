import std/[sequtils, strutils]

proc drawSquare(n: Positive) =
  let s1 = repeat(1, n).join(" ")
  let s2 = (1 & repeat(0, n - 2) & 1).join(" ")
  echo s1
  for i in 2..<n: echo s2
  echo s1

drawSquare(7)
