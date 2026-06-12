see "working..." + nl
see "Numbers in base-16 representation that cannot be written with decimal digits:" + nl

row = 0
baseList = "ABCDEF"
limit = 500

for n = 1 to limit
    flag = 1
    hex = upper(hex(n))
    for m = 1 to len(hex)
        ind = substr(baseList,hex[m])
        if ind < 1
           flag = 0
           exit
        ok
    next

    if flag = 1
       see "" + n + " "
       row = row + 1
       if row%5 = 0
          see nl
       ok
    ok
next

see nl + "Found " + row + " numbers" + nl
see "done..." + nl
