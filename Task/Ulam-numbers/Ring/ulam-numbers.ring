load "stdlib.ring"

limit = 12500
Ulam = []
add(Ulam,1)
add(Ulam,2)

for n = 3 to limit
    flag = 0
    count = 0
    len = len(Ulam)
    for x = 1 to len-1
        for y = x+1 to len
            if Ulam[x] + Ulam[y] = n
               flag = 1
               count = count + 1
            ok
        next
     next
     if flag = 1 and count = 1
        add(Ulam,n)
        ln = len(Ulam)
        if ln = 10
           see "The 10th Ulam number is: " + n + nl
        ok
        if ln = 100
           see "The 100th Ulam number is: " + n + nl
        ok
        if ln = 1000
           see "The 1000th Ulam number is: " + n + nl
        ok
        if ln = 10000
           see "The 10000th Ulam number is: " + n + nl
        ok
     ok
next
