import bignum, strformat

const

  Primes = [2, 3, 5, 7, 11, 13, 17]
  Digits = "0123456789abcdefghijklmnopqrstuvwxyz"

#---------------------------------------------------------------------------------------------------

func isProbablyPrime(n: Int): bool =
  ## Return true if "n" is not definitively composite.
  probablyPrime(n, 25) != 0

#---------------------------------------------------------------------------------------------------

func maxLeftTruncablePrime(base: int): Int =
  ## Return the maximum left truncable prime for given base.

  let base = base.int32
  var primes: seq[Int]

  # Initialize primes with one digit in given base.
  for p in Primes:
    if p < base:
      primes.add(newInt(p))
    else:
      break

  # Build prime list with one more digit per generation.
  var next: seq[Int]
  while true:

    # Build the next generation (with one more digit).
    for p in primes:
      var pstr = ' ' & `$`(p, base)   # ' ' as a placeholder for next digit.
      for i in 1..<base:
        pstr[0] = Digits[i]
        let n = newInt(pstr, base)
        if n.isProbablyPrime():
          next.add(n)

    if next.len == 0:
      # No primes with this number of digits.
      # Return the greatest prime in previous generation.
      return max(primes)

    # Prepare to build next generation.
    primes = next
    next.setLen(0)

#———————————————————————————————————————————————————————————————————————————————————————————————————

echo "Base    Greatest left truncable prime"
echo "====================================="
for base in 3..17:
  let m = maxLeftTruncablePrime(base)
  echo &"{base:>3}     {m}", if base > 10: " (" & `$`(m, base.int32) & ')' else: ""
