proc isPrime(n: Positive): bool =
  ## Check if a number is prime.
  if n mod 2 == 0:
    return n == 2
  if n mod 3 == 0:
    return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0:
      return false
    if n mod (d + 2) == 0:
      return false
    inc d, 6
  result = true

proc sameDigits(n, b: Positive): bool =
  ## Check if the digits of "n" in base "b" are all the same.
  var d = n mod b
  var n = n div b
  if d == 0:
    return false
  while n > 0:
    if n mod b != d:
      return false
    n = n div b
  result = true

proc isBrazilian(n: Positive): bool =
  ## Check if a number is brazilian.
  if n < 7:
    return false
  if (n and 1) == 0:
    return true
  for b in 2..(n - 2):
    if sameDigits(n, b):
      return true

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  import strutils

  template printList(title: string; findNextToCheck: untyped) =
    ## Template to print a list of brazilians numbers.
    ## "findNextTocheck" is a list of instructions to find the
    ## next candidate starting for the current one "n".

    block:
      echo '\n' & title
      var n {.inject.} = 7
      var list: seq[int]
      while true:
        if n.isBrazilian():
          list.add(n)
          if list.len == 20: break
        findNextToCheck
      echo list.join(", ")


  printList("First 20 Brazilian numbers:"):
    inc n

  printList("First 20 odd Brazilian numbers:"):
    inc n, 2

  printList("First 20 prime Brazilian numbers:"):
    inc n, 2
    while not n.isPrime():
      inc n, 2
