import strformat
from strutils import insertSep

func isPrime(i: int): bool =
  if i == 2 or i == 3: return true
  elif i mod 2 == 0 or i mod 3 == 0: return false
  var idx = 5
  while idx*idx <= i:
    if i mod idx == 0: return false
    idx.inc 2
    if i mod idx == 0: return false
    idx.inc 4
  result = true

const limit = 42
proc main =
  var
    i = 42
    n = 0
  while n < limit:
    if i.isPrime:
      inc n
      echo &"""n {n:>2} = {($i).insertSep(sep=','):>19}"""
      i.inc i
      continue
    inc i

main()
