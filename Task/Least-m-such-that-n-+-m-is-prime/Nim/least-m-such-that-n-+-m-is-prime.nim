import std/strformat
import integers

const Lim = 10000
const Step = 1000

var n = 0
var lim = 1000
var f = newInteger(1)
echo "Least positive m such that n! + m is prime; first 50:"
while true:
  var m = nextPrime(f) - f
  if n < 50:
    stdout.write &"{m:3}"
    stdout.write if n mod 10 == 9: '\n' else: ' '
    if n == 49: echo()
  else:
    while m > lim:
      echo &"First m > {lim:5} is {m:5} at position {n}."
      inc lim, Step
    if lim > Lim: break
  inc n
  f *= n
