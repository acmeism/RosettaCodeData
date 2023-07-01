load "stdlib.ring"

see "First 25 Smarandache primes:" + nl + nl

num = 0
limit = 26
limit100 = 100
for n = 1 to 34000
    flag = 0
    nStr = string(n)
    for x = 1 to len(nStr)
        nx = number(nStr[x])
        if isprime(n) and isprime(nx)
           flag = flag + 1
        else
           exit
        ok
     next
     if flag = len(nStr)
        num = num + 1
        if num < limit
           see "" + n + " "
        ok
        if num = limit100
           see nl + nl + "100th Smarandache prime: " + n + nl
        ok
     ok
next
