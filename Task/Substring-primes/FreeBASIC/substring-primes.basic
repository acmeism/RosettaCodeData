#include "isprime.bas"

function is_ssp(n as uinteger) as boolean
    if not isprime(n) then return false
    if n < 10 then return true
    if not isprime(n mod 100) then return false
    if not isprime(n mod 10) then return false
    if not isprime(n\10) then return false
    if n < 100 then return true
    if not isprime(n\100) then return false
    if not isprime( (n mod 100)\10 ) then return false
    return true
end function

for i as uinteger = 1 to 500
    if is_ssp(i) then print i;" ";
next i
print
