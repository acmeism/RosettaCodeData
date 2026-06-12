function numdig( byval n as uinteger ) as uinteger
    'number of decimal digits in n
    dim as uinteger d=0
    while n
        d+=1
        n\=10
    wend
    return d
end function

function is_steady_square( n as const uinteger ) as boolean
    dim as integer n2 = n^2
    if n2 mod 10^numdig(n) = n then return true else return false
end function

for i as uinteger = 1 to 10000
    if is_steady_square(i) then print using "####^2 = ########";i;i^2
next i
