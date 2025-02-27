load "stdlib.ring"

see "working..." + nl

for i = 1 to 5000
    if isWeiferich(i)
       see "" + i + nl
    ok
next

see "done..." + nl

function isWeiferich(p)
    if not isPrime(p)
       return False
    ok
    q = 1
    p2 = pow(p,2)
    while p > 1
        q = (2 * q) % p2
        p -= 1
    end
    if q = 1
       return True
    else
       return False
    ok
