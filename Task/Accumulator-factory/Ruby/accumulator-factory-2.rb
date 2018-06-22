require 'rational'
require 'complex'
y = accumulator(Rational(2, 3))
puts y[Rational(1, 2)]  # 7/6
puts y[4]               # 31/6
puts y[Complex(0, 1)]   # 31/6+1i

t = accumulator(Time.utc(1999, 8, 7, 6, 5))
                       # (Ruby 1.8.6)                  (Ruby 1.9.2)
puts t[4]              # Sat Aug 07 06:05:04 UTC 1999  1999-08-07 06:05:04 UTC
puts t[-12 * 60 * 60]  # Fri Aug 06 18:05:04 UTC 1999  1999-08-06 18:05:04 UTC

require 'matrix'
m = accumulator(Matrix[[1, 2], [3, 4]])
puts m[Matrix[[5, 6], [7, 8]]]  # Matrix[[6, 8], [10, 12]]
