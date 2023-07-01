function numdiv( n as uinteger ) as uinteger
    dim as uinteger c = 1
    for i as uinteger = 1 to (n+1)\2
        if n mod i = 0 then c += 1
    next i
    if n=1 then c-=1
    return c
end function

for i as uinteger = 1 to 100
   print numdiv(i),
   if i mod 10 = 0 then print
next i
