load "stdlib.ring"

sum = 0
limit = 1000000
aPrimes = []

for n = 1 to limit
    sum = 0
    st = string(n)
    for m = 1 to len(st)
        num = number(st[m])
        if isprime(num)
           sum = sum + num
           flag = 1
        else
           flag = 0
           exit
        ok
     next
     if flag = 1 and sum = 13
        add(aPrimes,n)
     ok
next

see "Unlucky numbers are:" + nl
see showArray(aPrimes)

func showarray vect
     svect = ""
     for n in vect
         svect += "" + n + ","
     next
     ? "[" + left(svect, len(svect) - 1) + "]"
