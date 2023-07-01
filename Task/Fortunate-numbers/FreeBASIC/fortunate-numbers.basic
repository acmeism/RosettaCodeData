#include "isprime.bas"
#include "sets.bas"
#include "bubblesort.bas"

function prime(n as uinteger) as uinteger
    if n = 1 then return 2
    dim as integer c=1, p=3
    while c<n
        if isprime(p) then c+=1
        p += 2
    wend
    return p
end function

function primorial( n as uinteger ) as ulongint
    dim as ulongint ret = 1
    for i as uinteger = 1 to n
        ret *= prime(i)
    next i
    return ret
end function

function fortunate(n as uinteger) as uinteger
    dim as uinteger m = 3
    dim as ulongint pp = primorial(n)
    while not isprime(m+pp)
        m+=2
    wend
    return m
end function

redim as integer forts(-1)
dim as integer n = 0, m
while ubound(forts) < 6
    n += 1
    m = fortunate(n)
    if not is_in(m, forts()) then
        add_to_set(m, forts())
    end if
wend

bubblesort(forts())
for n=0 to 6
    print forts(n)
next n
