str    = []
people = [2,3,5,11]

result = people
for i in people
    str = []
    see "" + i + ": "
    fair(25, i)
    for n in result
        add(str,n)
    next
    showarray(str)
next

func fair n,base

     result = list(n)
     for i=1 to n
         j = i-1
         t = 0
         while j>0
               t = t + j % base
               j = floor(j/base)
         end
         result[i] = t % base
     next

func showarray vect
     svect = ""
     for n in vect
         svect += " " + n + ","
     next
     svect = left(svect, len(svect) - 1)
     ? "[" + svect + "]"
