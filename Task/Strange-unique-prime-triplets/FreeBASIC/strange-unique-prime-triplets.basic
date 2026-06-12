#include"isprime.bas"

dim as uinteger c = 0

for p as uinteger = 3 to 997
    if not isprime(p) then continue for
    for m as uinteger = p + 1 to 998
        if not isprime(m) then continue for
        for n as uinteger = m + 1 to 999
            if not isprime(n) then continue for
            if isprime(p + n + m) then
                c = c + 1
                if n < 30 then print p;" + ";m;" + ";n;" = "; p + m + n
            end if
        next n
    next m
next p

print "There are ";c;" triples below 1000."
