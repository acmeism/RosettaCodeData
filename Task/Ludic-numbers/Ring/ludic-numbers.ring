# Project : Ludic numbers
# Date    : 2017/11/07
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

ludic = list(300)
resludic = []
nr = 1
for n = 1 to len(ludic)
     ludic[n] = n+1
next
see "the first 25 Ludic numbers are:" + nl
ludicnumbers(ludic)
showarray(resludic)
see nl

see "Ludic numbers below 1000: "
ludic = list(3000)
resludic = []
for n = 1 to len(ludic)
     ludic[n] = n+1
next
ludicnumbers(ludic)
showarray2(resludic)
see nr
see nl + nl

see "the 2000..2005th Ludic numbers are:" + nl
ludic = list(60000)
resludic = []
for n = 1 to len(ludic)
     ludic[n] = n+1
next
ludicnumbers(ludic)
showarray3(resludic)

func ludicnumbers(ludic)
      for n = 1 to len(ludic)
          delludic = []
          for m = 1 to len(ludic) step ludic[1]
              add(delludic, m)
          next
          add(resludic, ludic[1])
          for p = len(delludic)  to 1 step -1
              del(ludic, delludic[p])
          next
      next

func showarray(vect)
      see "[1, "
      svect = ""
      for n = 1 to 24
          svect = svect + vect[n] + ", "
      next
      svect = left(svect, len(svect) - 2)
      see svect
      see "]" + nl

func showarray2(vect)
      for n = 1 to len(vect)
          if vect[n] <= 1000
             nr = nr + 1
          ok
      next
      return nr

func showarray3(vect)
      see "["
      svect = ""
      for n = 1999 to 2004
          svect = svect + vect[n] + ", "
      next
      svect = left(svect, len(svect) - 2)
      see svect
      see "]" + nl
