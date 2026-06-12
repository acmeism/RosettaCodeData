#include "isprime.bas"
dim as uinteger i = 1, p, sum = 0
for p = 2 to 999
    if isprime(p) then
        if i mod 2 = 1 then
            sum += p
            if isprime(sum) then print i, p, sum
        end if
        i = i + 1
    end if
next p
