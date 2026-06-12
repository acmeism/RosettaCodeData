load "stdlibcore.ring"
see "working..." + nl
row = 0
limit = 2500

for p = 1 to limit
    flag = 1
    if isprime(p)
       for k = 1 to p
           if factorial(k) < p
              temp = p - factorial(k)
              if not isprime(temp)
                 flag = 1
              else
                 flag = 0
                 exit
              ok
           else
              exit
           ok
        next
     else
        flag = 0
     ok
     if flag = 1
        row++
        see "" + p + " "
        if row % 5 = 0
           see nl
        ok
     ok
next

see nl + "Found " + row + " Erdos primes less than 2500" + nl
see "done..." + nl
