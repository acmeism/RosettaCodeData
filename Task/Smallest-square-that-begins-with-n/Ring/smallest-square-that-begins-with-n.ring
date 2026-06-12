load "stdlib.ring"

see "working..." + nl
see "smallest squares that begin with n:" + nl

row = 0
limit1 = 49
limit2 = 45369

for n = 1 to limit1
    strn = string(n)
    lenn = len(strn)
    for m = 1 to limit2
        floor = sqrt(m)
        bool = (m % floor = 0)
        strm = string(m)
        if left(strm,lenn) = n and bool = 1
           row = row + 1
           see "" + strm + " "
           if row%5 = 0
              see nl
           ok
           exit
        ok
     next
next

see nl + "done..." + nl
