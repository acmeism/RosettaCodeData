load "stdlib.ring"

see "working..." + nl
see "the first 15 terms of the sequence are:" + nl

for n = 1 to 15
    for m = 1 to 4100
        pnum = 0
        for p = 1 to 4100
            if (m % p = 0)
               pnum = pnum + 1
            ok
        next
        if pnum = n
           see "" + m + " "
           exit
        ok
     next
next

see nl + "done..." + nl
