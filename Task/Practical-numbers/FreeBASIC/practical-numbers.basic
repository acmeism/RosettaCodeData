sub make_divisors( n as uinteger, div() as uinteger )
     'produces a list of an integer's proper divisors
     for i as uinteger = n/2 to 1 step -1
         if n mod i = 0 then
             redim preserve div(1 to 1 + ubound(div))
             div(ubound(div)) = i
         end if
     next i
end sub

function sum_divisors( n as uinteger, div() as uinteger ) as uinteger
    'takes a list of divisors and an integer which, when interpreted
    'as binary, selects which terms to sum
    dim as uinteger sum = 0, term = 1
    while n
        if n mod 2 = 1 then sum += div(term)
        term += 1
        n\=2
    wend
    return sum
end function

function is_practical( n as uinteger ) as boolean
    'determines if an integer is practical
    if n = 1 then return true
    if n mod 2 = 1 then return false    'there can be no odd practicals other than 1
    if n < 5 then return true           '2 and 4 are practical, but small enough to be handled specially
    dim as uinteger hits(1 to n-1), nt, i, sd
    redim as uinteger div(0 to 0)
    make_divisors( n, div() )
    nt = ubound(div)
    for i = 1 to 2^nt-1
        sd = sum_divisors(i, div())
        if sd<n then hits(sd)+=1
    next i
    for i = 1 to n-1
        if hits(i) = 0 then return false
    next i
    return true
end function

print 1;" ";  'treat 1 as a special case

for n as uinteger = 2 to 666
    if is_practical(n) then print n;" ";
next n:print
