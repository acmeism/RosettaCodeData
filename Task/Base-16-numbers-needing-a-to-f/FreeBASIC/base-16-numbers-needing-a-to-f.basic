function needs_af( byval n as uinteger ) as boolean
    while n>0
        if n mod 16 > 9 then return true
        n\=16
    wend
    return false
end function

for i as uinteger = 1 to 500
    if needs_af(i) then print i;" ";
next i
