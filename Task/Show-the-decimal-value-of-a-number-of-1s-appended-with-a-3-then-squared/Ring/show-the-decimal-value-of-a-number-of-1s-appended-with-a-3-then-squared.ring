load "stdlib.ring"

decimals(0)

see "working..." + nl

row = 0
limit = 8

str = "3"
for n = 1 to limit
    if n = 1
       strn = number(str)
       res = pow(strn,2)
       see "{" + strn + "," + res + "}" + nl
    else
       str = "1" + strn
       strn = number(str)
       res = pow(strn,2)
       see "{" + strn + "," + res + "}" + nl
    ok
next

see "done..." + nl
