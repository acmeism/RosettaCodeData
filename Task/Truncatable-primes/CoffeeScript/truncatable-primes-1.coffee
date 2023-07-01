# You could have symmetric algorithms for max right and left
# truncatable numbers, but they lend themselves to slightly
# different optimizations.

max_right_truncatable_number = (n, f) ->
  # This algorithm only evaluates 37 numbers for primeness to
  # get the max right truncatable prime < 1000000.  Its
  # optimization is that it prunes candidates for
  # the first n-1 digits before having to iterate through
  # the 10 possibilities for the last digit.
  if n < 10
    candidate = n
    while candidate > 0
      return candidate if f(candidate)
      candidate -= 1
  else
    left = Math.floor n / 10
    while left > 0
      left = max_right_truncatable_number left, f
      right = 9
      while right > 0
        candidate = left * 10 + right
        return candidate if candidate <= n and f(candidate)
        right -= 1
      left -= 1
  throw Error "none found"

max_left_truncatable_number = (max, f) ->
  # This is a pretty straightforward countdown.  The first
  # optimization here would probably be to cache results of
  # calling f on small numbers.
  is_left_truncatable = (n) ->
    candidate = 0
    power_of_ten = 1
    while n > 0
      r = n  % 10
      return false if r == 0
      n = Math.floor n / 10
      candidate = r * power_of_ten + candidate
      power_of_ten *= 10
      return false unless f(candidate)
    true
  do ->
    n = max
    while n > 0
      return n if is_left_truncatable n, f
      n -= 1
    throw Error "none found"

is_prime = (n) ->
  return false if n == 1
  return true if n == 2
  for d in [2..n]
    return false if n % d == 0
    return true if d * d >= n


console.log "right", max_right_truncatable_number(999999, is_prime)
console.log "left", max_left_truncatable_number(999999, is_prime)
