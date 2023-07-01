load "stdlib.ring"

decList = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
baseList = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
brazil = []
brazilOdd = []
brazilPrime = []
num1 = 0
num2 = 0
num3 = 0
limit = 20

see "working..." + nl
for n = 1 to 2802
    for m = 2 to 16
        flag = 1
        basem = decimaltobase(n,m)
        for p = 1 to len(basem)-1
            if basem[p] != basem[p+1]
               flag = 0
               exit
            ok
        next
        if flag = 1 and m < n - 1
           add(brazil,n)
           delBrazil(brazil)
        ok
        if flag = 1 and m < n - 1 and n % 2 = 1
           add(brazilOdd,n)
           delBrazil(brazilOdd)
        ok
        if flag = 1 and m < n - 1 and isprime(n)
           add(brazilPrime,n)
           delBrazil(brazilPrime)
        ok
    next
next

see "2 <= base <= 16" + nl
see "first 20 brazilian numbers:" + nl
showarray(brazil)
see "first 20 odd brazilian numbers:" + nl
showarray(brazilOdd)
see "first 11 brazilian prime numbers:" + nl
showarray(brazilPrime)

see "done..." + nl

func delBrazil(brazil)
     for z = len(brazil) to 2 step -1
         if brazil[z] = brazil[z-1]
            del(brazil,z)
         ok
     next

func decimaltobase(nr,base)
     binList = []
     binary = 0
     remainder = 1
     while(nr != 0)
          remainder = nr % base
          ind = find(decList,remainder)
          rem = baseList[ind]
          add(binList,rem)
          nr = floor(nr/base)
     end
     binlist = reverse(binList)
     binList = list2str(binList)
     binList = substr(binList,nl,"")
     return binList

func showArray(array)
     txt = ""
     if len(array) < limit
        limit = len(array)
     ok
     for n = 1 to limit
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     see txt + nl
