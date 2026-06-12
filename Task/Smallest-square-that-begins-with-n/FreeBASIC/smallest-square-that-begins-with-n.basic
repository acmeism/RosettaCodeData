dim as uinteger ssq(1 to 49), count = 0, curr = 1, curr2
dim as string scurr2
while count < 49
    curr2 = curr^2
    scurr2 = str(curr2)
    for j as uinteger = 1 to 49
        if val(left(scurr2, len(str(j)))) = j and ssq(j) = 0 then
            ssq(j) = curr2
            count += 1
        end if
    next j
    curr += 1
wend

print "Prefix        n^2            n"
print "------------------------------"

for j as uinteger = 1 to 49
    print j, ssq(j), sqr(ssq(j))
next j
