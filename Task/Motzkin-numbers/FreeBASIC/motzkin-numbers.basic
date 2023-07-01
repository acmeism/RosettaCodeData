#include "isprime.bas"

dim as ulongint M(0 to 41)
M(0) = 1 : M(1) = 1
print "1" : print "1"
for n as integer = 2 to 41
    M(n) = M(n-1)
    for i as uinteger = 0 to n-2
        M(n) += M(i)*M(n-2-i)
    next i
    print M(n),
    if isprime(M(n)) then print "is a prime" else print
next n
