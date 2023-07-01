import strformat

const MAX = 120

proc isPrime(n: int): bool =
  var d = 5
  if n < 2:
    return false
  if n mod 2 == 0:
    return n == 2
  if n mod 3 == 0:
    return n == 3
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, 2
    if n mod d == 0:
      return false
    inc d, 4
  return true

proc countPrimeFactors(n_in: int): int =
  var count = 0
  var f = 2
  var n = n_in
  if n == 1:
    return 0
  if isPrime(n):
    return 1
  while true:
    if n mod f == 0:
      inc count
      n = n div f
      if n == 1:
        return count
      if isPrime(n):
        f = n
    elif (f >= 3):
      inc f, 2
    else:
      f = 3

proc main() =
  var n, count: int = 0
  echo fmt"The attractive numbers up to and including {MAX} are:"
  for i in 1..MAX:
    n = countPrimeFactors(i)
    if isPrime(n):
      write(stdout, fmt"{i:4d}")
      inc count
      if count mod 20 == 0:
        write(stdout, "\n")
  write(stdout, "\n")

main()
