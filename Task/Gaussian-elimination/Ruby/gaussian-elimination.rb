require 'bigdecimal/ludcmp'
include LUSolve

BigDecimal::limit(30)

a = [1.00, 0.00, 0.00, 0.00, 0.00, 0.00,
     1.00, 0.63, 0.39, 0.25, 0.16, 0.10,
     1.00, 1.26, 1.58, 1.98, 2.49, 3.13,
     1.00, 1.88, 3.55, 6.70, 12.62, 23.80,
     1.00, 2.51, 6.32, 15.88, 39.90, 100.28,
     1.00, 3.14, 9.87, 31.01, 97.41, 306.02].map{|i|BigDecimal(i,16)}
b = [-0.01, 0.61, 0.91, 0.99, 0.60, 0.02].map{|i|BigDecimal(i,16)}

n = 6
zero = BigDecimal("0.0")
one  = BigDecimal("1.0")

lusolve(a, b, ludecomp(a, n, zero,one), zero).each{|v| puts v.to_s('F')[0..20]}
