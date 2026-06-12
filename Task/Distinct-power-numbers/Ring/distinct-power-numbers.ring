load "stdlib.ring"

see "working..." + nl
see "Distinct powers are:" + nl
row = 0
distPow = []

for n = 2 to 5
    for m = 2 to 5
        sum = pow(n,m)
        add(distPow,sum)
    next
next

distPow = sort(distPow)

for n = len(distPow) to 2 step -1
    if distPow[n] = distPow[n-1]
       del(distPow,n-1)
    ok
next

for n = 1 to len(distPow)
    row++
    see "" + distPow[n] + " "
    if row%5 = 0
       see nl
    ok
next

see "Found " + row + " numbers" + nl
see "done..." + nl
