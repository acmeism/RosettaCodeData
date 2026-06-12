load "stdlib.ring"
see "working..." + nl
see "i p sum" + nl

nr = 0
sum = 0
limit = 1000

for n = 2 to limit
    if isprime(n)
       nr++
       if nr%2 = 1
          sum += n
          if isprime(sum)
             see "" + nr + " " + n + " " + sum + nl
          ok
       ok
    ok
next

see "done..." + nl
