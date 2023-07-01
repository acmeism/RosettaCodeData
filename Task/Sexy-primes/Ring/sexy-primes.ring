load "stdlib.ring"

primes = []
for n = 1 to 100
    if isprime(n)
       add(primes,n)
    ok
next

see "Sexy prime pairs under 100:" + nl + nl
for n = 1 to len(primes)-1
    for m = n + 1 to len(primes)
        if primes[m] - primes[n] = 6
           see "(" + primes[n] +  " " + primes[m] + ")" + nl
        ok
    next
next
see nl

see "Sexy prime triplets under 100:" + nl +nl
for n = 1 to len(primes)-2
    for m = n + 1 to len(primes)-1
        for x = m + 1 to len(primes)
            bool1 = (primes[m] - primes[n] = 6)
            bool2 = (primes[x] - primes[m] = 6)
            bool = bool1 and bool2
            if bool
               see "(" + primes[n] +  " " + primes[m] + " " + primes[x] + ")" + nl
            ok
        next
    next
next
see nl

see "Sexy prime quadruplets under 100:" + nl + nl
for n = 1 to len(primes)-3
    for m = n + 1 to len(primes)-2
        for x = m + 1 to len(primes)-1
            for y = m + 1 to len(primes)
                bool1 = (primes[m] - primes[n] = 6)
                bool2 = (primes[x] - primes[m] = 6)
                bool3 = (primes[y] - primes[x] = 6)
                bool = bool1 and bool2 and bool3
                if bool
                   see "(" + primes[n] +  " " + primes[m] + " " + primes[x] + " " + primes[y] + ")" + nl
                ok
             next
        next
    next
next
see nl

see "Sexy prime quintuplets under 100:" + nl + nl
for n = 1 to len(primes)-4
    for m = n + 1 to len(primes)-3
        for x = m + 1 to len(primes)-2
            for y = m + 1 to len(primes)-1
                for z = y + 1 to len(primes)
                    bool1 = (primes[m] - primes[n] = 6)
                    bool2 = (primes[x] - primes[m] = 6)
                    bool3 = (primes[y] - primes[x] = 6)
                    bool4 = (primes[z] - primes[y] = 6)
                    bool = bool1 and bool2 and bool3 and bool4
                    if bool
                       see "(" + primes[n] + " " + primes[m] + " " + primes[x] + " " +
                                 primes[y] + " " + primes[z] + ")" + nl
                    ok
                 next
             next
        next
    next
next
