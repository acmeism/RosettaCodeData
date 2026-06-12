load "stdlib.ring"
see "working..." + nl
see "Concatenate two primes is also prime:" + nl
row = 0
prime = []

for n = 1 to 100
    for m = 1 to 100
        ps1 = string(n)
        ps2 = string(m)
        ps12 = ps1 + ps2
        ps21 = ps2 + ps1
        p1 = number(ps12)
        p2 = number(ps21)
        if isprime(n) and isprime(m)
           if isprime(p1)
              pf = find(prime,p1)
              if pf < 1
                 add(prime,p1)
              ok
           ok
           if isprime(p2)
              pf = find(prime,p2)
              if pf < 1
                 add(prime,p2)
              ok
           ok
        ok
    next
next

prime = sort(prime)
for n = 1 to len(prime)
    row++
    see "" + prime[n] + " "
    if row%10 = 0
       see nl
    ok
next

see nl + "Found " + row + " prime numbers" + nl
see "done..." + nl
