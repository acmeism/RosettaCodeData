# Using int(n) allows non-integer "n" inputs with the factorial
# calculated on int(n) in that case.
# Arranging the condition as "n>=2" avoids infinite recursion if
# n==NaN, since any comparison involving NaN is false.  Could change
# "1" to an expression like "n*0+1" to propagate a NaN input to the
# output too, if desired.
#
factorial(n) = (n >= 2 ? int(n)*factorial(n-1) : 1)
set xrange [0:4.95]
set key left
plot factorial(x)
