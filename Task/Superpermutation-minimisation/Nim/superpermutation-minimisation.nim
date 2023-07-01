import strformat

const MAX = 12

var super: seq[char] = @[]
var pos: int
var cnt: array[MAX, int]

proc factSum(n: int): int =
  var s, x = 0
  var f = 1
  while x < n:
    inc x
    f *= x
    inc s, f
  s

proc r(n: int): bool =
  if n == 0:
    return false
  var c = super[pos - n]
  dec cnt[n]
  if cnt[n] == 0:
    cnt[n] = n
    if not r(n - 1):
      return false
  super[pos] = c
  inc pos
  true

proc superperm(n: int) =
  pos = n
  var le = factSum(n)
  super.setLen(le)
  for i in 0..n:
    cnt[i] = i
  for i in 1..n:
    super[i-1] = char(i + ord('0'))
  while r(n):
    discard
for n in 0..<MAX:
  write(stdout, fmt"superperm({n:2})")
  superperm(n)
  writeLine(stdout, fmt" len = {len(super)}")
