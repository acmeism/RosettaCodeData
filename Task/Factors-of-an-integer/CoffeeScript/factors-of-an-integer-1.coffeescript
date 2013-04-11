# Reference implementation for finding factors is slow, but hopefully
# robust--we'll use it to verify the more complicated (but hopefully faster)
# algorithm.
slow_factors = (n) ->
  (i for i in [1..n] when n % i == 0)

# The rest of this code does two optimizations:
#   1) When you find a prime factor, divide it out of n (smallest_prime_factor).
#   2) Find the prime factorization first, then compute composite factors from those.

smallest_prime_factor = (n) ->
  for i in [2..n]
    return n if i*i > n
    return i if n % i == 0

prime_factors = (n) ->
  return {} if n == 1
  spf = smallest_prime_factor n
  result = prime_factors(n / spf)
  result[spf] or= 0
  result[spf] += 1
  result

fast_factors = (n) ->
  prime_hash = prime_factors n
  exponents = []
  for p of prime_hash
    exponents.push
      p: p
      exp: 0
  result = []
  while true
    factor = 1
    for obj in exponents
      factor *= Math.pow obj.p, obj.exp
    result.push factor
    break if factor == n
    # roll the odometer
    for obj, i in exponents
      if obj.exp < prime_hash[obj.p]
        obj.exp += 1
        break
      else
        obj.exp = 0

  return result.sort (a, b) -> a - b

verify_factors = (factors, n) ->
  expected_result = slow_factors n
  throw Error("wrong length") if factors.length != expected_result.length
  for factor, i in expected_result
    console.log Error("wrong value") if factors[i] != factor


for n in [1, 3, 4, 8, 24, 37, 1001, 11111111111, 99999999999]
  factors = fast_factors n
  console.log n, factors
  if n < 1000000
    verify_factors factors, n
