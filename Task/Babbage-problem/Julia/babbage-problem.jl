"""
    babbage(x::Integer)

    Returns the smallest positive integer whose square ends in `x`
"""
function babbage(x::Integer)
  i = big(0)   # start with 0 and increase by 1 until target reaached
  d = 10^ndigits(x)  # smallest power of 10 greater than x
  while (i * i) % d != x
    i += 1  # try next squre of numbers 0, 1, 2, ...
  end
  return i
end
