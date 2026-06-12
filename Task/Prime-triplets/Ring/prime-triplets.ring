load "stdlib.ring"
see "working..." + nl
see "Initial members of prime triples (p, p+2, p+6) are:" + nl
see "p p+2 p+6" + nl
row = 0
limit = 5500

for n = 1 to limit
    if isprime(n) and isprime(n+2) and isprime(n+6)
       row = row + 1
       see "" + n + " " + (n+2) + " " + (n+6) + nl
    ok
next

see "Found " + row + " primes" + nl
see "done..." + nl
