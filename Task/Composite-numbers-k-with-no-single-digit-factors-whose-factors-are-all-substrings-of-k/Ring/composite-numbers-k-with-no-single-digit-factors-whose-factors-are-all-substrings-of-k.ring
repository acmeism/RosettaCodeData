load "stdlib.ring"

Result = []
deco = []
comList = []
nEnd = 3500000

for n = 1 to nEnd
    nr = 0
    for p = 1 to n
        if n%p = 0
           if isPrime(p) = true and p<10
              exit
           else
              nr = nr + 1
           ok
        ok
    next
    if nr > 2
       comStr = string(n)
       add(comList,comStr)
    ok
next

for n = 1 to len(comList)
    num = 0
    comStr = comList[n]
    comNum = number(comStr)
    comTemp = comStr
    decomp(deco,comNum)
    for y = 1 to len(deco)
        ind = substr(comStr,deco[y])
        if ind > 0
           num = num + 1
        ok
    next
    if num = len(deco)
       add(Result,comTemp)
    ok
next

see Result

func decomp(deco,nr2)
     deco = []
     x = ""
     for i = 1 to nr2
         if isPrime(i) and nr2 % i = 0
            x = string(i)
            add(deco,x)
         ok
     next
     return deco
