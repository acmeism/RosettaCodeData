load "stdlib.ring"

see "work..." + nl
for n = 3 to 10000000 step 2
    n1 = n
    n2 = n+2
    if isPrime(n1) and isPrime(n2)
       sum = n1 + n2
       if sqrt(sum) = ceil(sqrt(sum))
          see "" + n1 + " + " + n2 + " = " + sqrt(sum) + "*" + sqrt(sum) + nl
       ok
    ok
next
see "done..." + nl
