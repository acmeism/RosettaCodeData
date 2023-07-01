function numdiv( n as uinteger ) as uinteger
    dim as uinteger c = 2
    for i as uinteger = 2 to (n+1)\2
        if n mod i = 0 then c += 1
    next i
    return c
end function

function istau( n as uinteger ) as boolean
    if n = 1 then return true
    if n mod numdiv(n) = 0 then return true else return false
end function

dim as uinteger c = 0, i=1
while c < 100
    if istau(i) then
        print i,
        c += 1
        if c mod 10 = 0 then print
    end if
    i += 1
wend
