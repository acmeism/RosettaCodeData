load "stdlib.ring"

see "working..." + nl
see "Special neighbor primes are:" + nl
row = 0
oldPrime = 2

for n = 3 to 100
    if isprime(n) and isprime(oldPrime)
       sum = oldPrime + n - 1
       if isprime(sum)
          row++
          see "" + oldPrime + "," + n + " => " + sum + nl
       ok
       oldPrime = n
    ok
next

see "Found " + row + " special neighbor primes"
see "done..." + nl
