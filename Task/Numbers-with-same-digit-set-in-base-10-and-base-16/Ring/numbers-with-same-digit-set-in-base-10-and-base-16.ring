see "working..." + nl

row = 0
limit = 100000

for n = 0 to limit
    flag1 = 1
    flag2 = 1
    decStr = string(n)
    hexStr = hex(n)
    for m = 1 to len(decStr)
        ind = substr(hexStr,decStr[m])
        if ind < 1
           flag1 = 0
           exit
        ok
    next
    for p = 1 to len(hexStr)
        ind = substr(decStr,hexStr[p])
        if ind < 1
           flag2 = 0
           exit
        ok
    next
    if flag1 = 1 and flag2 = 1
       row = row + 1
       see "" + n + " "
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
