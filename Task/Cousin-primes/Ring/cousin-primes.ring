load "stdlib.ring"

see "working..." + nl
see "cousin primes are:" + nl

ind = 0
row = 0
limit = 1000
cousin = []

for n = 1 to limit
    if isprime(n) and isprime(n+4)
       row = row + 1
       ind1 = find(cousin,n)
       ind2 = find(cousin,n+4)
       if ind1 < 1
          add(cousin,n)
       ok
       if ind2 < 1
          add(cousin,n+4)
       ok
       see "(" + n + ", " + (n+4) + ") "
          if row%5 = 0
             see nl
          ok
    ok
next

lencousin = len(cousin)
see nl + "found " + row + " cousin prime pairs." + nl
see "found " + lencousin + " unique cousin primes." + nl

see "done..." + nl
