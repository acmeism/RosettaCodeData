load "stdlib.ring"
see "working..." + nl

Primes = []
Numbers1 = [5,45,23,21,67]
Numbers2 = [43,22,78,46,38]
Numbers3 = [9,98,12,54,53]

for n = 1 to len(Numbers1)
    Temp = []
    add(Temp,Numbers1[n])
    add(Temp,Numbers2[n])
    add(Temp,Numbers3[n])
    max = max(Temp)
    max--
    while true
          max++
          if isprime(max)
             exit
          ok
    end
    add(Primes,max)
next

see "Minimum primes = "
see showArray(Primes)
see nl + "done..." + nl

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
