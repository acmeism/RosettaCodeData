load "stdlib.ring"
see "working..." + nl
see "Numbers n with property that the sum of the digits of n is substring of n are:" + nl
see "p p+2 p+6" + nl
row = 0
limit = 1000

for n = 0 to limit-1
    str = 0
    strn = string(n)
    for m = 1 to len(strn)
        str = str + number(strn[m])
    next
    str = string(str)
    ind = substr(strn,str)
    if ind > 0
       row = row + 1
       see "" + n + " "
       if row%10 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
