load "stdlib.ring"

limit = list(7)
for n = 1 to 7
    limit[n] = pow(10,n)
next

TwinPrimes = []

for n = 1 to limit[7]-2
    bool1 = isprime(n)
    bool2 = isprime(n+2)
    bool = bool1 and bool2
    if bool =1
       add(TwinPrimes,[n,n+2])
    ok
next

numTwin = list(7)
len = len(TwinPrimes)

for n = 1 to len
    for p = 1 to 6
        if TwinPrimes[n][2] < pow(10,p) and TwinPrimes[n+1][1] > pow(10,p)-2
           numTwin[p] = n
        ok
    next
next

numTwin[7] = len

for n = 1 to 7
    see "Maximum: " + pow(10,n) + nl
    see "twin prime pairs below " + pow(10,n) + ": " + numTwin[n] + nl + nl
next
