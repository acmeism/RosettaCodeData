load "stdlib.ring"
see "working..." + nl
see "Neighbour primes are:" + nl
see "p q p*q+2" + nl

row = 0
num = 0
pr = 0
limit = 100
Primes = []

while true
    pr = pr + 1
    if isprime(pr)
       add(Primes,pr)
       num = num + 1
       if num = limit
          exit
       ok
    ok
end

for n = 1 to limit-1
    prim = Primes[n]*Primes[n+1]+2
    if isprime(prim)
       row = row + 1
       see "" + Primes[n] + " " + Primes[n+1] + " " + prim + nl
    ok
next

see "Found " + row + " neighbour primes" + nl
see "done..." + nl
