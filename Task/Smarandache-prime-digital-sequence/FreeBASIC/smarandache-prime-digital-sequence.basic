function isprime( n as ulongint ) as boolean
    if n < 2 then return false
    if n = 2 then return true
    if n mod 2 = 0 then return false
    for i as uinteger = 3 to int(sqr(n))+1 step 2
        if n mod i = 0 then return false
    next i
    return true
end function

dim as integer smar(1 to 100), count = 1, i = 1, digit, j
smar(1) = 2
print 1, 2
while count < 100
    i += 2
    if not isprime(i) then continue while
    for j = 1 to len(str(i))
        digit = val(mid(str(i),j,1))
        if not isprime(digit) then continue while
    next j
    count += 1
    smar(count) = i
    if count = 100 orelse count <=25 then
        print count, smar(count)
    end if
wend
