see "working..." + nl
see "Minimum positive multiple in base 10 using only 0 and 1:" + nl

limit1 = 1000
limit2 = 111222333444555666777889
plusflag = 0
plus = [297,576,594,891,909,999]

for n = 1 to limit1
    if n = 106
       plusflag = 1
       nplus = 0
    ok
    lenplus = len(plus)
    if plusflag = 1
       nplus = nplus + 1
       if nplus < lenplus+1
          n = plus[nplus]
       else
          exit
       ok
    ok
    for m = 1 to limit2
        flag = 1
        prod = n*m
        pstr = string(prod)
        for p = 1 to len(pstr)
            if not(pstr[p] = "0" or pstr[p] = "1")
               flag = 0
               exit
            ok
        next
        if flag = 1
           see "" + n + " * " + m + " = " + pstr + nl
           exit
        ok
    next
    if n = 10
       n = 94
    ok
next

see "done..." + nl
