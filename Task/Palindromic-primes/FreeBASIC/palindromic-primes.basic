#include "isprime.bas"

function is_pal( s as string ) as boolean
    dim as integer i, n = len(s)
    for i = 1 to n\2
        if mid(s,i,1)<>mid(s,n-i+1,1) then return false
    next i
    return true
end function

for i as uinteger = 2 to 999
    if is_pal( str(i) ) andalso isprime(i) then  print i;" ";
next i : print
