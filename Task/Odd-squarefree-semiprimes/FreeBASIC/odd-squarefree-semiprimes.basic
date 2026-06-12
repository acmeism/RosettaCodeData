#include "isprime.bas"
dim as integer p, q
for p = 3 to 999
    if not isprime(p) then continue for
    for q = p+1 to 1000\p
        if not isprime(q) then continue for
        print p*q;" ";
    next q
next p
