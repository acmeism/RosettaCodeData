load "stdlib.ring"

decimals(0)
see "working..." + nl
see "Numbers divisible by their individual digits, but not by the product of their digits are:" + nl

row = 0
limit = 1000

for n = 1 to limit
    flag = 1
    pro = 1
    strn = string(n)
    for m = 1 to len(strn)
        temp = strn[m]
        if temp != 0
           pro = pro * number(temp)
        ok
        if n%temp = 0
           flag = 1
        else
           flag = 0
           exit
        ok
     next
     bool = ((n%pro) != 0)
     if flag = 1 and bool
        row = row + 1
        see "" + n + " "
        if row%10 = 0
           see nl
        ok
     ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
