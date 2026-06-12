import strutils

var s = 0
for n in 0..49:
  s += n * n * n
  stdout.write ($s).align(7), if (n + 1) mod 10 == 0: '\n' else: ' '
