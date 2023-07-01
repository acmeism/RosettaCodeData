load "stdlib.ring"
see "working..." + nl
see "Product of decimal digits of n:" + nl

row = 0
limit = 100

for n = 1 to limit
    prod = 1
    strn = string(n)
    for m = 1 to len(strn)
        prod = prod * number(strn[m])
    next
    see "" + prod + " "
    row = row + 1
    if row%5 = 0
       see nl
    ok
next

see "done..." + nl
