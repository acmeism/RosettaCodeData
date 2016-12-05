alist = []
blist = []
alist = ["john", "bob", "mary", "serena"]
blist = ["jim", "mary", "john", "bob"]

alist2 = []
for i = 1 to len(alist)
    flag = 0
    for j = 1 to len(blist)
        if alist[i] = blist[j]  flag = 1 ok
    next
    if (flag = 0) add(alist2, alist[i]) ok
next

blist2 = []
for j = 1 to len(alist)
    flag = 0
    for i = 1 to len(blist)
        if alist[i] = blist[j]  flag = 1 ok
    next
    if (flag = 0) add(blist2, blist[j]) ok
next
see "a xor b :" see nl
see alist2
see blist2 see nl
see "a-b :" see nl
see alist2 see nl
see "b-a :" see nl
see blist2 see nl
