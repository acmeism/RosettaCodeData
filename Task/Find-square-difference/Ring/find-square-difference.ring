load "stdlib.ring"
see "working..." + nl
limit1 = 6000
limit2 = 1000
oldPrime = 0
newPrime = 0

for n = 1 to limit1
    newPrime = n*n
    if newPrime - oldPrime > limit2
       see "Latest number is = " + sqrt(newPrime) + nl
       exit
    ok
    oldPrime = n*n
next

see "done..." + nl
