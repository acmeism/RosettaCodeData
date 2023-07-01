import strformat
import strutils
import math

const cutOff = 200
const bigUn = 100000
const chunks = 50
const little = bigUn div chunks

echo fmt"The first {cutOff} cuban primes"
var primes: seq[int] = @[3, 5]
var c, u = 0
var showEach: bool = true
var v = 1
for i in 1..high(BiggestInt):
  var found: bool
  inc u, 6
  inc v, u
  var mx = int(ceil(sqrt(float(v))))
  for item in primes:
    if item > mx:
      break
    if v mod item == 0:
      found = true
      break
  if not found:
    inc c
    if showEach:
      for z in countup(primes[^1] + 2, v - 2, step=2):
        var fnd: bool = false
        for item in primes:
          if item > mx:
            break
          if z mod item == 0:
            fnd = true
            break
        if not fnd:
          primes.add(z)
      primes.add(v)
      write(stdout, fmt"{insertSep($v, ','):>11}")
      if c mod 10 == 0:
        write(stdout, "\n")
      if c == cutOff:
        showEach = false
        write(stdout, fmt"Progress to the {bigUn}th cuban prime: ")
        stdout.flushFile
    if c mod little == 0:
      write(stdout, ".")
      stdout.flushFile
      if c == bigUn:
        break
write(stdout, "\n")
echo fmt"The {c}th cuban prime is {insertSep($v, ',')}"
