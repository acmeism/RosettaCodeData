load "stdlib.ring"

see "working..." + nl

Primes = []
limit1 = 50
oldPrime = 2
add(Primes,2)

for n = 1 to limit1
    nextPrime = oldPrime + pow(n,3)
    if isprime(nextPrime)
       n = 1
       add(Primes,nextPrime)
       oldPrime = nextPrime
    else
       nextPrime = nextPrime - oldPrime
    ok
next

see "prime1 prime2 Gap Cbrt" + nl
for n = 1 to Len(Primes)-1
    diff = Primes[n+1] - Primes[n]
    for m = 1 to diff
        if pow(m,3) = diff
           cbrt = m
           exit
        ok
    next
    see ""+ Primes[n] + "      " + Primes[n+1] + "    " + diff + "     " + cbrt + nl
next

see "Found " + Len(Primes) + " of the smallest primes < 15,000  such that the difference of successive terma are the smallest cubic numbers" + nl

see "done..." + nl
