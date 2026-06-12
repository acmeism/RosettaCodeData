load "stdlib.ring"

decimals(0)
see "working..." + nl
see "Piprimes are:" + nl

row = 0
limit1 = 400
Prim = []

for n = 1 to limit1
    if isprime(n)
       add(Prim,n)
    ok
next

for n = 1 to len(Prim)
    for m = 1 to len(Prim)
        if Prim[m] > n
           ind = m - 1
           exit
        ok
    next
    row = row + 1
    see "" + ind + " "
    if row%10 = 0
       see nl
    ok
next

see nl + "Found " + row + " Piprimes." + nl
see "done..." + nl
