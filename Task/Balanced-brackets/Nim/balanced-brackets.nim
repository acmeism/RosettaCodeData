from random import random, randomize, shuffle
from strutils import repeat

randomize()

proc gen(n: int): string =
  result = "[]".repeat(n)
  shuffle(result)

proc balanced(txt: string): bool =
  var b = 0
  for c in txt:
    case c
    of '[':
      inc(b)
    of ']':
      dec(b)
      if b < 0: return false
    else: discard
  b == 0

for n in 0..9:
  let s = gen(n)
  echo "'", s, "' is ", (if balanced(s): "balanced" else: "not balanced")
