#include "isprime.bas"

dim as integer pn=2, n=0, f
for i as integer = 3 to 9999 step 2
    if isprime(i) then
        n += 1
        f = pn*i - pn - i
        if f > 10000 then end
        print n, f
        pn = i
    end if
next i
