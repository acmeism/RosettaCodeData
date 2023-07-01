load "stdlib.ring"

see "working..." + nl
see "Additive primes are:" + nl

row = 0
limit = 500

for n = 1 to limit
    num = 0
    if isprime(n)
       strn = string(n)
       for m = 1 to len(strn)
           num = num + number(strn[m])
       next
       if isprime(num)
          row = row + 1
          see "" + n + " "
          if row%10 = 0
             see nl
          ok
       ok
    ok
next

see nl + "found " + row + " additive primes." + nl
see "done..." + nl
