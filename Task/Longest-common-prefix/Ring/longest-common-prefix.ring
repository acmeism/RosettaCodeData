# Project : Longest common prefix

aList1 = ["interspecies","interstellar","interstate"]
aList2 = list(len(aList1))
flag = 1
comp=""
for n=1 to len(aList1[1])
    aList2 = list(len(aList1))
    flag=1
    for m=1 to len(aList1)
        aList2[m] = left(aList1[m], n )
        compare =  left(aList1[1], n )
    next
    for p=1 to len(aList1)
        if aList2[p] != compare
           flag = 0
           exit
        ok
    next
    if flag=1
       if len(compare) > comp
          comp=compare
        ok
     ok
next
if comp=""
   see "none"
else
   see comp + nl
ok
