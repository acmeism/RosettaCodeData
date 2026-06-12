#include"isprime.bas"

function digsum( byval n as uinteger, b as const uinteger ) as uinteger
    'finds the digit sum of n in base b
    dim as uinteger sum = 0
    while n
        sum+=n mod b
        n\=b
    wend
    return sum
end function

for n as uinteger = 1 to 200
    if isprime(digsum(n,2)) and isprime(digsum(n,3)) then print n;"  ";
next n : print
