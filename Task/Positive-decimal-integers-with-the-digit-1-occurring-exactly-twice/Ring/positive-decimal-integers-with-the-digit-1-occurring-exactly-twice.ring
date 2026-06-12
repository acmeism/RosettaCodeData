load "stdlib.ring"
see "working..." + nl
see "Numbers n in which number 1 occur twice:" + nl

row = 0
sum = 0
limit = 1000

for n = 1 to limit
    strn = string(n)
    ind = count(strn,"1")
    if ind = 2
       see "" + n + " "
       row++
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl

func count(cstring,dstring)
     sum = 0
     while substr(cstring,dstring) > 0
           sum++
           cstring = substr(cstring,substr(cstring,dstring)+len(string(sum)))
     end
     return sum
