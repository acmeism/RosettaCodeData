load "stdlib.ring"
see "working..." + nl
sum = 2
limit = 2000000

for n = 3 to limit step 2
    if isprime(n)
       sum += n
    ok
next

see "The sum of all the primes below two million:" + nl
see "" + sum + nl
see "done..." + nl
