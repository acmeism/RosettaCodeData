load "stdlib.ring"

decimals(0)
limit = 19

for n = 2 to limit
    fact = factorial(n-1) + 1
    see "Is " + n + " prime: "
    if fact % n = 0
       see "1" + nl
    else
       see "0" + nl
    ok
next
