load "stdlib.ring"
see "working..." +nl
row = 0
limit = 1500
Sophie = []

for n = 1 to limit
    p = 2*n + 1
    if isprime(n) and isprime(p)
       add(Sophie,n)
    ok
next

see "Found " + len(Sophie) + " Safe and Sophie German primes."+nl

for n = 1 to len(Sophie)
    row++
    see "" + Sophie[n] + " "
    if row % 10 = 0
       see nl
    ok
next

see "done..." + nl
