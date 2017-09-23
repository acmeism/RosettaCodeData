say agm(1, 1/rxcalcsqrt(2))

::routine agm
  use strict arg a, g
  numeric digits 20

  a1 = a
  g1 = g

  loop while abs(a1 - g1) >= 1e-14
      temp = (a1 + g1)/2
      g1 = rxcalcsqrt(a1 * g1)
      a1 = temp
  end
  numeric digits 9
  return a1+0

::requires rxmath LIBRARY
