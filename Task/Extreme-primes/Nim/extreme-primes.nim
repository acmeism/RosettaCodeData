import std/[strformat, strutils]
import integers

echo "First 30 extreme primes:"
var ep = newInteger(0)
var count =  0
var lim = 1000
var p = newInteger(2)
while true:
  ep += p
  p = p.nextPrime
  if ep.isPrime:
    inc count
    if count <= 30:
      stdout.write &"{ep:>6}"
      stdout.write if count mod 6 == 0: '\n' else: ' '
      if count == 30: echo()
    elif count == lim:
      echo &"Sum of {count} in prime series up to {insertSep($p):>9}: prime {insertSep($ep):>14}"
      inc lim, 1000
      if lim > 5000: break
