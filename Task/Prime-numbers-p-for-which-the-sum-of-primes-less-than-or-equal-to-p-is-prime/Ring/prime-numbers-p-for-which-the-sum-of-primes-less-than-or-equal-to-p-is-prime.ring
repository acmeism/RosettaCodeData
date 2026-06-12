load "stdlib.ring"
see "working..." + nl
see "Prime numbers p which sum of prime numbers less or equal to p is prime:" + nl

row = 0
sum = 0
limit = 1000

for n = 1 to limit
    if isprime(n)
       sum = sum + n
       if isprime(sum)
          see "" + n + " "
          row++
          if row%5 = 0
             see nl
          ok
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
