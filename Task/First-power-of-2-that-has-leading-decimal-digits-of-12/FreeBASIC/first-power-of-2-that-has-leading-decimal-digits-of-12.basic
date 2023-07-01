#define FAC 0.30102999566398119521373889472449302677

function p( L as uinteger, n as uinteger ) as uinteger
    dim as uinteger count, j = 0
    dim as double x, y
    dim as string digits, LS = str(L)
    while count < n
        j+=1
        x = FAC * j
        if x < len(LS) then continue while
        y = 10^(x-int(x))
        y *= 10^len(LS)
        digits  = str(y)
        if left(digits,len(LS)) = LS then count += 1
    wend
    return j
end function

print p(12, 1)
print p(12, 2)
print p(123, 45)
print p(123, 12345)
print p(123, 678910)
