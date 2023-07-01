#include "isprime.bas"

print 1,2,2
dim as integer sum = 2, i, n=1
for i = 3 to 999 step 2
    if isprime(i) then
        sum += i
        n+=1
        if isprime(sum) then
            print n, i, sum
        end if
    end if
next i
