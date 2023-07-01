import strformat

proc farey(n: int) =
  var f1 = (d: 0, n: 1)
  var f2 = (d: 1, n: n)
  write(stdout, fmt"0/1 1/{n}")
  while f2.n > 1:
    let k = (n + f1.n) div f2.n
    let aux = f1
    f1 = f2
    f2 = (f2.d * k - aux.d, f2.n * k - aux.n)
    write(stdout, fmt" {f2.d}/{f2.n}")
  write(stdout, "\n")

proc fareyLength(n: int, cache: var seq[int]): int =
  if n >= cache.len:
    var newLen = cache.len
    if newLen == 0:
      newLen = 16
    while newLen <= n:
      newLen *= 2
    cache.setLen(newLen)
  elif cache[n] != 0:
    return cache[n]

  var length = n * (n + 3) div 2
  var p = 2
  var q = 0
  while p <= n:
    q = n div (n div p) + 1
    dec length, fareyLength(n div p, cache) * (q - p)
    p = q
  cache[n] = length
  return length

for n in 1..11:
  write(stdout, fmt"{n:>8}: ")
  farey(n)

var cache: seq[int] = @[]
for n in countup(100, 1000, step=100):
  echo fmt"{n:>8}: {fareyLength(n, cache):14} items"

let n = 10_000_000
echo fmt"{n}: {fareyLength(n, cache):14} items"
