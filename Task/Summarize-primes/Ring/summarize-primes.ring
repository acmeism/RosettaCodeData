load "stdlib.ring"
see "working..." + nl
see "Summarize primes:" + nl
see "n sum" + nl
row = 0
sum = 0
limit = 1000
Primes = []

for n = 2 to limit
    if isprime(n)
       add(Primes,n)
    ok
next

for n = 1 to len(Primes)
    sum = sum + Primes[n]
    if isprime(sum)
       row = row + 1
       see "" + n + " " + sum + nl
    ok
next

see "Found " + row + " numbers" + nl
see "done..." + nl
