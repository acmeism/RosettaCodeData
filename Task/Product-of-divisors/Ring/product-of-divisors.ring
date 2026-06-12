limit = 50
row = 0

see "working..." + nl

for n = 1 to limit
    pro = 1
    for m = 1 to n
        if n%m = 0
           pro = pro*m
        ok
    next
    see "" + pro + " "
    row = row + 1
    if row % 5 = 0
       see nl
    ok
next

see "done..." + nl
