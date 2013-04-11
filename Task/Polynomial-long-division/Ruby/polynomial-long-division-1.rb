def polynomial_long_division(numerator, denominator)
  dd = degree(denominator)
  raise ArgumentError, "denominator is zero" if dd < 0
  if dd == 0
    return [multiply(numerator, 1.0/denominator[0]), [0]*numerator.length]
  end

  q = [0] * numerator.length

  while (dn = degree(numerator)) >= dd
    d = shift_right(denominator, dn - dd)
    q[dn-dd] = numerator[dn] / d[degree(d)]
    d = multiply(d, q[dn-dd])
    numerator = subtract(numerator, d)
  end

  [q, numerator]
end

def degree(ary)
  idx = ary.rindex {|x| x.nonzero?}
  idx.nil? ? -1 : idx
end

def shift_right(ary, n)
  [0]*n + ary[0, ary.length - n]
end

def subtract(a1, a2)
  a1.zip(a2).collect {|v1,v2| v1 - v2}
end

def multiply(ary, num)
  ary.collect {|x| x * num}
end

f = [-42, 0, -12, 1]
g = [-3, 1, 0, 0]
q, r = polynomial_long_division(f, g)
p [f, g, q, r]
# => [[-42, 0, -12, 1], [-3, 1, 0, 0], [-27, -9, 1, 0, 0], [-123, 0, 0, 0, 0]]

g = [-3, 1, 1, 0]
q, r = polynomial_long_division(f, g)
p [f, g, q, r]
# => [[-42, 0, -12, 1], [-3, 1, 0, 0], [-13, 1, 0, 0, 0], [-81, 16, 0, 0, 0]]
