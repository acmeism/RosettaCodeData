load "stdlibcore.ring"
? "working"

Primes = [2,43,81,122,63,13,7,95,103]
Temp = []

for n = 1 to len(Primes)
     if isprime(Primes[n])
        add(Temp,Primes[n])
     ok
next

Temp = sort(Temp)
showarray(Temp)
? "done..."

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     ? txt
