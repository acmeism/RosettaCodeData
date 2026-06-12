import strutils

func digitsum(n: Natural): int =
  if n == 0: return 0
  var n = n
  while n != 0:
    result += n mod 10
    n = n div 10

var count = 0
for n in 0..<1000:
  let sn = $n
  if $digitsum(n) in sn:
    inc count
    stdout.write sn.align(3), if count mod 8 == 0: '\n' else: ' '
