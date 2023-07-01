load "stdlib.ring"
see "working..." + nl + nl
see "For primes less than 1,000,000:" + nl + nl
num = 0
limit = 1000000
Primes = []
SuccPrimes = []
Sp = [[2],[1],[2,2],[2,4],[4,2],[6,4,2]]

for n = 1 to limit
    if isprime(n)
       add(Primes,n)
    ok
next

for n = 1 to len(Sp)
    num = 0
    for m = 1 to len(Primes)-len(Sp[n])
        flag = 0
        SuccPrimes = []
        for p = 1 to len(Sp[n])
            if (Primes[m+p]-Primes[m+p-1] = Sp[n][p])
               flag++
               add(SuccPrimes,Primes[m+p])
               add(SuccPrimes,Primes[m+p-1])
            else
               exit
            ok
        next

        SuccPrimes = sort(SuccPrimes)
        for x = len(SuccPrimes) to 2 step -1
            if SuccPrimes[x] = SuccPrimes[x-1]
               del(SuccPrimes,x)
            ok
        next

        if len(SuccPrimes) = len(Sp[n])+1
           num++
           LastSuccPrimes = SuccPrimes
           if num = 1
              see "For differences of "
              showArray(Sp[n])
              see " ->" + nl
              see " First group = "
              showArray(SuccPrimes)
              see nl
           ok
        ok
    next
    see " Last group = "
    showArray(LastSuccPrimes)
    see nl
    see " Number found = " + num + nl + nl
 next

see "done..." + nl

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
