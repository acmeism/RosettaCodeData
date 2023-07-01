import std/[math, sequtils, strformat]

func getStep(n: int): int {.inline.} =
  result = 1 + n shl 2 - n shr 1 shl 1

func primeFac(n: int): seq[int] =
  var
    maxq = int(sqrt(float(n)))
    d = 1
    q: int = 2 + (n and 1)   # Start with 2 or 3 according to oddity.

  while q <= maxq and n %% q != 0:
    q = getStep(d)
    inc d
  if q <= maxq:
    let q1 = primeFac(n /% q)
    let q2 = primeFac(q)
    result = concat(q2, q1, result)
  else:
    result.add(n)

func squareFree(num: int): bool =
  let fact = primeFac num

  for i in fact:
    if fact.count(i) > 1:
      return false

  return true

func mobius(num: int): int =
  if num == 1: return num

  let fact = primeFac num

  for i in fact:
    ## check if it has a squared prime factor
    if fact.count(i) == 2:
      return 0

  if num.squareFree:
    if fact.len mod 2 == 0:
      return 1
    else:
      return -1

when isMainModule:
  echo "The first 199 möbius numbers are:"

  for i in 1..199:
    stdout.write fmt"{mobius(i):4}"
    if i mod 20 == 0:
      echo "" # print newline
