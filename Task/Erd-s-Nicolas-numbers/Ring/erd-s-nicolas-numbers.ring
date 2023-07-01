see "works..." + nl
erdos = []
limit = 1600000
for n = 1 to limit
    num = 0
    sum = 0
    erdos = []
    for m = 1 to n/2
        if n%m = 0
           add(erdos,m)
        ok
    next
    lenErdos = len(erdos)
    for p = 1 to lenErdos
        sum = sum + erdos[p]
        if sum = n and p < lenErdos
           num++
           see "" + n + " equals the sum of its first " + p + " divisors" + nl
           exit
        ok
    next
    if num = 8
       exit
    ok
next
see "done..." + nl
