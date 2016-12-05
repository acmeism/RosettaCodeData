import strutils

proc z(n): string =
  if n == 0: return "0"
  var fib = @[2,1]
  var n = n
  while fib[0] < n: fib.insert(fib[0] + fib[1])
  result = ""
  for f in fib:
    if f <= n:
      result.add '1'
      n -= f
    else:
      result.add '0'
  if result[0] == '0':
    result = result[1..result.high]

for i in 0 .. 20:
  echo align($i, 3)," ",align(z(i), 8)
