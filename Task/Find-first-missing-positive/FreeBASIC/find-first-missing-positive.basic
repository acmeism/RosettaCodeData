function is_in( n() as integer, k as uinteger ) as boolean
    for i as uinteger = 1 to ubound(n)
        if n(i) = k then return true
    next i
    return false
end function

function fmp( n() as integer ) as integer
    dim as uinteger i = 1
    while is_in( n(), i )
        i+=1
    wend
    return i
end function

dim as integer a(1 to 3) = {1, 2, 0}
dim as integer b(1 to 4) = {3, 4, -1, 1}
dim as integer c(1 to 5) = {7, 8, 9, 11, 12}

print fmp(a())
print fmp(b())
print fmp(c())
