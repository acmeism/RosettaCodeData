function is_substring( s as string, j as string ) as boolean
    dim as integer nj = len(j), ns = len(s)
    for i as integer = 1 to ns - nj + 1
        if mid(s,i,nj) = j then return true
    next i
    return false
end function

function sumdig( byval n as integer ) as integer
    dim as integer sum
    do
        sum += n mod 10
        n \= 10
    loop until n = 0
    return sum
end function

for i as uinteger = 0 to 999
    if is_substring( str(i), str(sumdig(i))) then print i;" ";
next i : print : end
