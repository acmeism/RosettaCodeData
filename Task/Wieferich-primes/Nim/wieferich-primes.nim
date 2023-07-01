import math
import bignum

func isPrime(n: Positive): bool =
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d <= sqrt(n.toFloat).int:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

echo "Wieferich primes less than 5000:"
let two = newInt(2)
for p in 2u..<5000:
  if p.isPrime:
    if exp(two, p - 1, p * p) == 1:    # Modular exponentiation.
      echo p
