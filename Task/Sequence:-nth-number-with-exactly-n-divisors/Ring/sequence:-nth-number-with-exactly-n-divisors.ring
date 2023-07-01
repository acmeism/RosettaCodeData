load "stdlib.ring"

num = 0
limit = 22563490300366186081

see "working..." + nl
see "the first 15 terms of the sequence are:" + nl

for n = 1 to 15
    num = 0
    for m = 1 to limit
        pnum = 0
        for p = 1 to limit
            if (m % p = 0)
               pnum = pnum + 1
            ok
        next
        if pnum = n
           num = num + 1
           if num = n
              see "" + n + ": " + m + " " + nl
              exit
           ok
        ok
     next
next

see nl + "done..." + nl
