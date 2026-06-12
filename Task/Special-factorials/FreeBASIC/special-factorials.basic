function factorial(n as uinteger) as ulongint
    if n<2 then return 1 else return n*factorial(n-1)
end function

function sf(n as uinteger) as ulongint
    dim as ulongint p=1
    for k as uinteger = 1 to n
        p*=factorial(k)
    next k
    return p
end function

function H( n as uinteger ) as ulongint
    dim as ulongint p=1
    for k as uinteger = 1 to n
        p*=k^k
    next k
    return p
end function

function af( n as uinteger ) as longint
    dim as longint s=0
    for i as uinteger = 1 to n
        s += (-1)^(n-i)*factorial(i)
    next i
    return s
end function

function ef( n as uinteger ) as ulongint
    if n<2 then return 1 else return n^ef(n-1)
end function

function rf( n as ulongint ) as integer
    dim as uinteger r=0,rr
    while true
        rr=factorial(r)
        if rr>n then return -1
        if rr=n then return r
        r+=1
    wend
end function

for n as uinteger = 0 to 7
    print sf(n), H(n), af(n)
next n
print
for n as uinteger = 0 to 4
    print ef(n);" ";
next n
print : print
for n as uinteger =0 to 9
    print rf(factorial(n));" ";
next n
print rf(119)
