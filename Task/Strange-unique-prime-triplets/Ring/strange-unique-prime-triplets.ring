load "stdlib.ring"

num = 0
limit = 30

see "working..." + nl
see "the strange primes are:" + nl

for n = 1 to limit
    for m = n+1 to limit
        for p = m+1 to limit
            sum = n+m+p
            if isprime(sum) and isprime(n) and isprime(m) and isprime(p)
               num = num + 1
               see "" + num + ": " + n + "+" + m + "+" + p + " = " + sum + nl
            ok
        next
    next
next

see "done..." + nl
