import bignum

var p = newInt(2)
for e in 1..10_000:
  if probablyPrime(p - 1, 25) != 0:
    echo "2^", e, " - 1"
  p *= 2
