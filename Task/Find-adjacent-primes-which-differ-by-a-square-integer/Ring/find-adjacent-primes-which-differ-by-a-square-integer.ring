load "stdlib.ring"
see "working..." + nl
limit = 1000000
Primes = []
oldPrime = 0
newPrime = 0
x = 0

for n = 1 to limit
    if isprime(n)
       add(Primes,n)
    ok
next

for n = 2 to len(Primes)
    pr1 = Primes[n]
    pr2 = Primes[n-1]
    diff = pr1 - pr2
    flag = issquare(diff)
    if flag = 1 and diff > 36
       see "" + pr1 + " " + pr2 + " diff = " + diff + nl
    ok
next

see "done..." + nl

func issquare(x)
     for n = 1 to sqrt(x)
         if x = pow(n,2)
            return 1
         ok
     next
     return 0
