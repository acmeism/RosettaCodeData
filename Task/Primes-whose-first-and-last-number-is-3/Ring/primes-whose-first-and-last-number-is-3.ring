load "stdlib.ring"
see "working..." + nl
see "Primes whose first and last number is 3" + nl
row = 0

for n = 1 to 4000
    strn = string(n)
    if left(strn,1) = "3" and right(strn,1) = "3" and isprime(n)
       see "" + n + " "
       row++
       if row%10 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
