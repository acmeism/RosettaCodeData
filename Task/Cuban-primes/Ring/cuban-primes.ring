load "stdlib.ring"

sum = 0
limit = 1000

see "First 200 cuban primes:" + nl

for n = 1 to limit
    pr = pow(n+1,3) - pow(n,3)
    if isprime(pr)
       sum = sum + 1
       if sum < 201
          see "" + pr + " "
       else
          exit
       ok
    ok
next

see "done..." + nl
