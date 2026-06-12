load "stdlib.ring"
see "working..." + nl
see "The largest prime factor of the number 600851475143 is:" + nl
num = 600851475143
numSqrt = sqrt(num)
numSqrt = floor(numSqrt)
if numSqrt%2 = 0
   numSqrt++
ok

for n = numSqrt to 3 step -2
    if isprime(n) and num%n = 0
       exit
    ok
next

see "" + n + nl
see "done..." + nl
