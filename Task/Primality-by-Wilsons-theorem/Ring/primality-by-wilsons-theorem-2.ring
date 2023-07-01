# primality by Wilson's theorem

limit = 100

for n = 1 to limit
    if isWilsonPrime( n )
       see " " + n
    ok
next n

func isWilsonPrime n
    fmodp = 1
    for i = 2 to n - 1
        fmodp *= i
        fmodp %= n
    next i
    return fmodp = n - 1
