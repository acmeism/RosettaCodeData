load "stdlib.ring"

see "working..." + nl

Primes = []
limit1 = 100
oldPrime = 2

for n = 1 to limit1
    nextPrime = oldPrime + n
    if isprime(nextPrime)
       add(Primes,nextPrime)
       oldPrime = nextPrime
    ok
next

see "prime1 prime2 Gap" + nl
for n = 1 to Len(Primes)-1
    diff = Primes[n+1] - Primes[n]
    see ""+ Primes[n] + "      " + Primes[n+1] + "    " + diff + nl
next

see nl + "done..." + nl

