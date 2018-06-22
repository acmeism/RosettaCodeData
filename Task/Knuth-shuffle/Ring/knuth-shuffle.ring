# Project : Knuth shuffle
# Date    : 2017/11/08
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

items = list(52)
for n = 1 to len(items)
      items[n] = n
next
knuth(items)
showarray(items)

func knuth(items)
       for i = len(items) to 1 step -1
            j = random(i-1) + 1
            if i != j
               temp = items[i]
               items[i] = items[j]
               items[j] = temp
            ok
       next

func showarray(vect)
       see "["
       svect = ""
       for n = 1 to len(vect)
           svect = svect + vect[n] + " "
       next
       svect = left(svect, len(svect) - 1)
       see svect
       see "]" + nl
