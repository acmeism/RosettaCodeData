import strformat

func isPrime(n: int): bool =
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  true

var count = 1
write(stdout, "    2")
for i in countup(3, 1999, 2):
  if isPrime(i):
    inc count
    write(stdout, fmt"{i:5}")
    if count mod 15 == 0:
      write(stdout, "\n")
echo()
