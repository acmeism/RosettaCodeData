numeric digits 20
say agm(1, 1/rxcalcsqrt(2,16))

::routine agm
  use strict arg a, g
  numeric digits 20

  a1 = a
  g1 = g

  loop while abs(a1 - g1) >= 1e-14
      temp = (a1 + g1)/2
      g1 = rxcalcsqrt(a1*g1,16)
      a1 = temp
  end
  return a1+0

::requires rxmath LIBRARY
