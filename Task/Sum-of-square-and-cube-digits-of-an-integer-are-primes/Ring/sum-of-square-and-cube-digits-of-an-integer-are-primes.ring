load "stdlib.ring"
see "working..." +nl

limit = 100

for n = 1 to limit
    sums = 0
    sumc = 0
    sps = string(pow(n,2))
    spc = string(pow(n,3))
    for m = 1 to len(sps)
        sums = sums + sps[m]
    next
    for p = 1 to len(spc)
        sumc = sumc + spc[p]
    next
    if isprime(sums) and isprime(sumc)
       see "" + n + " "
    ok
next

see nl + "done..." + nl
