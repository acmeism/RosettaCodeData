import bignum
import strformat

const SmallPrimes = [
  2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
  101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
  211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
  307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397,
  401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
  503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
  601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
  701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
  809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
  907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997]

let
  One = newInt(1)
  Two = newInt(2)
  Ten = newInt(10)

#---------------------------------------------------------------------------------------------------

proc isPrime(n: Int): bool =

  if n < Two: return false

  for sp in SmallPrimes:
    # let spb = newInt(sp)
    if n == sp: return true
    if (n mod sp).isZero: return false
    if n < sp * sp: return true

  result = probablyPrime(n, 25) != 0

#---------------------------------------------------------------------------------------------------

proc cycle(n: Int): Int =

  var m = n
  var p = 1
  while m >= Ten:
    p *= 10
    m = m div 10
  result = m + Ten * (n mod p)

#---------------------------------------------------------------------------------------------------

proc isCircularPrime(p: Int): bool =

  if not p.isPrime(): return false

  var p2 = cycle(p)
  while p2 != p:
    if p2 < p or not p2.isPrime():
      return false
    p2 = cycle(p2)
  result = true

#---------------------------------------------------------------------------------------------------

proc testRepunit(digits: int) =

  var repunit = One
  var count = digits - 1
  while count > 0:
    repunit = Ten * repunit + One
    dec count
  if repunit.isPrime():
    echo fmt"R({digits}) is probably prime."
  else:
    echo fmt"R({digits}) is not prime."

#---------------------------------------------------------------------------------------------------

echo "First 19 circular primes:"
var p = 2
var line = ""
var count = 0
while count < 19:
  if newInt(p).isCircularPrime():
    if count > 0: line.add(", ")
    line.add($p)
    inc count
  inc p
echo line

echo ""
echo "Next 4 circular primes:"
var repunit = One
var digits = 1
while repunit < p:
  repunit = Ten * repunit + One
  inc digits
line = ""
count = 0
while count < 4:
  if repunit.isPrime():
    if count > 0: line.add(' ')
    line.add(fmt"R({digits})")
    inc count
  repunit = Ten * repunit + One
  inc digits
echo line

echo ""
testRepUnit(5003)
testRepUnit(9887)
testRepUnit(15073)
testRepUnit(25031)
testRepUnit(35317)
testRepUnit(49081)
