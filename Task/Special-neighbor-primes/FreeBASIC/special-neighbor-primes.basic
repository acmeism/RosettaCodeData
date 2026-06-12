#include"isprime.bas"

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

dim as uinteger p1, p2

for p1 = 3 to 100 step 2
    p2 = nextprime(p1)
    if isprime(p1) andalso p2<100 andalso isprime( p1 + p2 - 1 ) then
        print p1, p2, p1 + p2 - 1
    end if
next p1
