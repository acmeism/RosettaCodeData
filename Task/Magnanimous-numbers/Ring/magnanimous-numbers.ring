load "stdlib.ring"
n = -1
sum = 0
magn = []

while sum < 45
      n = n + 1
      if n < 10
         add(magn,n)
         sum = sum + 1
      else
         nStr = string(n)
         check = 0
         for m = 1 to len(nStr)-1
             nr1 = number(left(nStr,m))
             nr2 = number(right(nStr,len(nStr)-m))
             nr3 = nr1 + nr2
             if not isprime(nr3)
                check = 1
             ok
          next
          if check = 0
             add(magn,n)
             sum = sum + 1
          ok
       ok
end

see "Magnanimous numbers 1-45:" + nl
showArray(magn)

n = -1
sum = 0
magn = []

while sum < 250
      n = n + 1
      if n < 10
         sum = sum + 1
      else
         nStr = string(n)
         check = 0
         for m = 1 to len(nStr)-1
             nr1 = number(left(nStr,m))
             nr2 = number(right(nStr,len(nStr)-m))
             nr3 = nr1 + nr2
             if not isprime(nr3)
                check = 1
             ok
          next
          if check = 0
             sum = sum + 1
          ok
          if check = 0 and sum > 240 and sum < 251
             add(magn,n)
          ok
       ok
end

see nl
see "Magnanimous numbers 241-250:" + nl
showArray(magn)

func showArray array
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
