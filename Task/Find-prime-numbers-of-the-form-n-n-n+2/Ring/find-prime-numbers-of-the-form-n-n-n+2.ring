load "stdlib.ring"

see "working..." + nl

for n = 1 to 200 step 2
    pr = pow(n,3)+2
    if isprime(pr)
       see "n = " + n + " => n³+2 = " + pr + nl
    ok
next

see "done..." + nl
