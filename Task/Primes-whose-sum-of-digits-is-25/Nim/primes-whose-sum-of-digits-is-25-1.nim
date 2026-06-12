import strutils, sugar

func isPrime(n: Natural): bool =
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

func digitSum(n: Natural): int =
  var n = n
  while n != 0:
    result += n mod 10
    n = n div 10

let result = collect(newSeq):
               for n in countup(3, 5000, 2):
                 if digitSum(n) == 25 and n.isPrime: n

for i, n in result:
  stdout.write ($n).align(4), if (i + 1) mod 6 == 0: '\n' else: ' '
echo()
