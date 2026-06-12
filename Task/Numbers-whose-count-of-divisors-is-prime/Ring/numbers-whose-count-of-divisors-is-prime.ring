load "stdlib.ring"
row = 0

see "working..." + nl
see "Numbers which count of divisors is prime are:" + nl

for n = 1 to 1000
    num = 0
    for m = 1 to n
        if n%m = 0
           num++
        ok
    next
    if isprime(num) and num != 2
       see "" + n + " "
       row++
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
