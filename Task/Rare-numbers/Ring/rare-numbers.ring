load "stdlib.ring"

see "working..." + nl
see "the first 5 rare numbers are:" + nl

num = 0

for n = 1 to 2042832002
    strn = string(n)
    nrev = ""
    for m = len(strn) to 1 step -1
        nrev = nrev + strn[m]
    next
    nrev = number(nrev)
    sum = n + nrev
    diff = n - nrev
    if diff < 1
       loop
    ok
    sqrtsum = sqrt(sum)
    flagsum = (sqrtsum = floor(sqrtsum))
    sqrtdiff = sqrt(diff)
    flagdiff= (sqrtdiff = floor(sqrtdiff))
    if flagsum = 1 and flagdiff = 1
       num = num + 1
       see "" + num + ": " + n + nl
    ok
next
see "done..." + nl
