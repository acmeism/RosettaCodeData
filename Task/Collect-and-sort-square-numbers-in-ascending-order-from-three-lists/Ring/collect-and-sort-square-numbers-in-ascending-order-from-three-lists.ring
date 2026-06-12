load "stdlib.ring"

see "working..." + nl
list = list(3)
list[1] = [3,4,34,25,9,12,36,56,36]
list[2] = [2,8,81,169,34,55,76,49,7]
list[3] = [75,121,75,144,35,16,46,35]
Primes = []

for n = 1 to 3
    for m = 1 to len(list[n])
        if issquare(list[n][m])
           add(Primes,list[n][m])
        ok
    next
next

Primes = sort(Primes)
showArray(Primes)

see nl + "done..." + nl

func issquare(x)
     for n = 1 to sqrt(x)
         if x = pow(n,2)
            return 1
         ok
     next
     return 0

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
