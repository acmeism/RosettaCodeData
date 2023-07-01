import strformat

proc iseban(n: int): bool =
  if n == 0:
    return false
  var b = n div 1_000_000_000
  var r = n mod 1_000_000_000
  var m = r div 1_000_000
  r = r mod 1_000_000
  var t = r div 1_000
  r = r mod 1_000
  m = if m in 30..66: m mod 10 else: m
  t = if t in 30..66: t mod 10 else: t
  r = if r in 30..66: r mod 10 else: r
  return {b, m, t, r} <= {0, 2, 4, 6}

echo "eban numbers up to and including 1000:"
for i in 0..100:
  if iseban(i):
    stdout.write(&"{i} ")

echo "\n\neban numbers between 1000 and 4000 (inclusive):"
for i in 1_000..4_000:
  if iseban(i):
    stdout.write(&"{i} ")

var count = 0
for i in 0..10_000:
  if iseban(i):
    inc count
echo &"\n\nNumber of eban numbers up to and including {10000:8}: {count:4}"

count = 0
for i in 0..100_000:
  if iseban(i):
    inc count
echo &"\nNumber of eban numbers up to and including {100000:8}: {count:4}"

count = 0
for i in 0..1_000_000:
  if iseban(i):
    inc count
echo &"\nNumber of eban numbers up to and including {1000000:8}: {count:4}"

count = 0
for i in 0..10_000_000:
  if iseban(i):
    inc count
echo &"\nNumber of eban numbers up to and including {10000000:8}: {count:4}"

count = 0
for i in 0..100_000_000:
  if iseban(i):
    inc count
echo &"\nNumber of eban numbers up to and including {100000000:8}: {count:4}"
