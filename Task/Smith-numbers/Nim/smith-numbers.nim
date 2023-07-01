import strformat

func primeFactors(n: int): seq[int] =
  result = newSeq[int]()
  var n = n
  var i = 2
  while n mod i == 0:
    result.add(i)
    n = n div i
  i = 3
  while i * i <= n:
    while n mod i == 0:
      result.add(i)
      n = n div i
    inc i, 2
  if n != 1:
    result.add(n)

func sumDigits(n: int): int =
  var n = n
  var sum = 0
  while n > 0:
    inc sum, n mod 10
    n = n div 10
  sum

var cnt = 0
for n in 1..10_000:
  var factors = primeFactors(n)
  if factors.len > 1:
    var sum = sumDigits(n)
    for f in factors:
      dec sum, sumDigits(f)
    if sum == 0:
      stdout.write(&"{n:4}  ")
      inc cnt
    if cnt == 10:
      cnt = 0
      stdout.write("\n")
echo()
