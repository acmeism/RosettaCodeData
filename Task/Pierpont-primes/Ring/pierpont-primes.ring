load "stdlib.ring"

see "working..." + nl

pierpont = []
limit1 = 18
limit2 = 8505000
limit3 = 50
limit4 = 21
limit5 = 30500000

for n = 0 to limit1
    for m = 0 to limit1
        num = pow(2,n)*pow(3,m) + 1
        if isprime(num) and num < limit2
           add(pierpont,num)
        ok
        if num > limit2
           exit
        ok
     next
next

pierpont = sort(pierpont)

see "First 50 Pierpont primes of the first kind:" + nl + nl

for n = 1 to limit3
    see "" + n + ". " + pierpont[n] + nl
next

see "done1..." + nl

pierpont = []

for n = 0 to limit4
    for m = 0 to limit4
        num = pow(2,n)*pow(3,m) - 1
        if isprime(num) and num < limit5
           add(pierpont,num)
        ok
        if num > limit5
           exit
        ok
     next
next

pierpont = sort(pierpont)

see "First 50 Pierpont primes of the second kind:" + nl + nl

for n = 1 to limit3
    see "" + n + ". " + pierpont[n] + nl
next

see "done2..." + nl
