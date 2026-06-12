load "stdlib.ring"
see "working..." + nl
see "Primes which contain only one odd number:" + nl
row = 0

for n = 1 to 1000
    odd = 0
    str = string(n)
    for m = 1 to len(str)
        if number(str[m])%2 = 1
           odd++
        ok
    next
    if odd = 1 and isprime(n)
       see "" + n + " "
       row++
       if row%5 = 0
          see nl
       ok
    ok
next

see "Found " + row + " prime numbers" + nl
see "done..." + nl
