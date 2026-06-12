#include "isprime.bas"

function nextprime( n as uinteger ) as uinteger
    'finds the next prime after n
    if n = 0 then return 2
    if n < 3 then return n + 1
    dim as integer q = n + 2
    while not isprime(q)
        q+=2
    wend
    return q
end function

function issquare( n as uinteger ) as boolean
    if int(sqr(n))^2 = n then return true else return false
end function

dim as uinteger i=3, j=0
while j<1000000
    j = nextprime(i)
    if j-i > 36 and issquare(j-i) then print i, j, j-i
    i = j
wend
