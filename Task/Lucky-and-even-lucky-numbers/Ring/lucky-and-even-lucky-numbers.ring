# Project : Lucky and even lucky numbers

lucky = list(50)
dellucky = []
for n = 1 to 50
     lucky[n] = 2*n-1
next
see "the first 20 lucky numbers:" + nl
luckynumbers(lucky)
showarray(lucky)
see nl

lucky = list(50)
dellucky = []
for n = 1 to 50
     lucky[n] = 2*n
next
see "the first 20 even lucky numbers:" + nl
luckynumbers(lucky)
showarray(lucky)
see nl

lucky = list(20000)
dellucky = []
for n = 1 to 10000
     lucky[n] = 2*n-1
next
see "lucky numbers between 6,000 and 6,100:" + nl
luckynumbers2(lucky)
showarray2(lucky)
see nl

lucky = list(20000)
dellucky = []
for n = 1 to 10000
     lucky[n] = 2*n
next
see "even lucky numbers between 6,000 and 6,100:" + nl
luckynumbers2(lucky)
showarray2(lucky)
see nl

func luckynumbers(lucky)
      for n = 2 to len(lucky)
          dellucky = []
          for m = lucky[n] to len(lucky) step lucky[n]
              add(dellucky, m)
          next
          for p = len(dellucky)  to 1 step -1
              del(lucky, dellucky[p])
          next
      next

func luckynumbers2(lucky)
      for n = 2 to len(lucky)
          dellucky = []
          for m = lucky[n] to len(lucky) step lucky[n]
              add(dellucky, m)
          next
          for p = len(dellucky)  to 1 step -1
              del(lucky, dellucky[p])
          next
          if lucky[n] >= 6100
             exit
          ok
next

func showarray(vect)
      see "["
      svect = ""
      for n = 1 to 20
          svect = svect + vect[n] + ", "
      next
      svect = left(svect, len(svect) - 2)
      see svect
      see "]" + nl

func showarray2(vect)
      see "["
      svect = ""
      for n = 1 to len(vect)
          if vect[n] >= 6000 and vect[n] <= 6100
             svect = svect + vect[n] + ", "
          ok
      next
      svect = left(svect, len(svect) - 2)
      see svect
      see "]" + nl
