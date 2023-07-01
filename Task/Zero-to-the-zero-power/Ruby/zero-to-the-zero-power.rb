require 'bigdecimal'

[0, 0.0, Complex(0), Rational(0), BigDecimal("0")].each do |n|
  printf "%10s: ** -> %s\n" % [n.class, n**n]
end
