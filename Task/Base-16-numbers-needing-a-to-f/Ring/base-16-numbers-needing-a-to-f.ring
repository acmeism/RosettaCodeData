see "working..." + nl
baseList = ["a","b","c","d","e","f"]
row = 1
limit = 500

for n = 1 to limit
    num = 0
    flag = 1
    hex = hex(n)
    lenHex = len(hex)
    for m = 1 to lenHex
        ind = find(baseList,hex[m])
        if ind < 1
           num = num + 1
        ok
    next
    if num != lenHex
       row = row + 1
       see "" + n + " "
       if row%10 = 0
          see nl
       ok
    ok
next

see nl + "done..." + nl
