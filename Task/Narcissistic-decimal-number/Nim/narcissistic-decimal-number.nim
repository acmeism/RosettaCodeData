import sequtils, strutils

func digits(n: Natural): seq[int] =
  result.add n mod 10
  var n = n div 10
  while n != 0:
    result.add n mod 10
    n = n div 10

proc findNarcissistic(count: Natural): seq[int] =
  var
    n = 0
    m = 10
    powers = toseq(0..9)
  while true:
    while n < m:
      var s = 0
      for d in n.digits:
        inc s, powers[d]
      if s == n:
        result.add n
        if result.len == count: return
      inc n
    for i in 0..9: powers[i] *= i
    m *= 10

echo findNarcissistic(25).join(" ")
