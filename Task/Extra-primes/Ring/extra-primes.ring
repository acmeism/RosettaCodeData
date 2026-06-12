load "stdlib.ring"

limit = 10000
num = 0
for n = 1 to limit
    x1 = prime1(n)
    x2 = prime2(n)
    x3 = isprime(n)
    if x1 = 1 and x2 = 1 and x3
       num = num + 1
       see "The " + num + "th Extra Prime is: " + n + nl
    ok
next

func prime1(x)
     pstr = string(x)
     len = len(pstr)
     count = 0
     for n = 1 to len
         if isprime(number(pstr[n]))
            count = count + 1
         ok
     next
     if count = len
        return 1
     else
        return 0
     ok

func prime2(x)
     pstr = string(x)
     len = len(pstr)
     sum = 0
     for n = 1 to len
         sum = sum + number(pstr[n])
     next
     if isprime(sum)
        return 1
     else
        return 0
     ok
