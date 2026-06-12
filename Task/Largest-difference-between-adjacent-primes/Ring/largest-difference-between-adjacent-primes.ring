load "stdlib.ring"
see "working..." + nl
limit = 1000000
Primes = []
maxOld = 0
newDiff = 0
oldDiff = 0

for n = 1 to limit
    newDiff = n - maxOld
    if isprime(n)
       if newDiff > oldDiff
          add(Primes,[n,maxOld])
          oldDiff = newDiff
       ok
       maxOld = n
    ok
next

len = len(Primes)
diff = Primes[len][1] - Primes[len][2]
see Primes[len(Primes)]
see nl + "Largest difference is = " + diff + nl
see "done..." + nl
