decimals(0)
load "stdlib.ring"

see "working..." + nl
see "The first 10 Fermat numbers are:" + nl

num = 0
limit = 9

for n = 0 to limit
    fermat = pow(2,pow(2,n)) + 1
    mod = fermat%2
    if n > 5
       ferm = string(fermat)
       tmp = number(right(ferm,1))+1
       fermat = left(ferm,len(ferm)-1) + string(tmp)
    ok
    see "F(" + n + ") = " + fermat + nl
next

see "done..." + nl
