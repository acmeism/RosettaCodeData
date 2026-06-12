load "stdlib.ring"
row = 0
limit = 1000
see "working..." + nl

for n = 1 to limit-1
    if issquare(n) and isprime(n+1)
       row++
       see "" + n +nl
    ok
next

see "Found " + row + " numbers" + nl
see "done..." + nl

func issquare(x)
     for n = 1 to sqrt(x)
         if x = pow(n,2)
            return 1
         ok
     next
     return 0
