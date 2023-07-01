list1 = "1, 2, 1, 5, 2"
list2 = "5, 2, 1, 5, 2, 2"
list3 = "1, 2, 3, 4, 5"
list4 = "1, 2, 3, 4, 5"

if order(list1, list2) = 0 see "list1=list2" + nl
but order(list1, list2) < 0 see "list1<list2" + nl
else see "list1>list2" + nl ok

if order(list2, list3) = 0 see "list2=list3" + nl
but order(list2, list3) < 0 see "list2<list3" + nl
else see "list2>list3" + nl ok

if order(list3, list4) = 0 see "list3=list4" + nl
but order(list3, list4) < 0 see "list3<list4" + nl
else see "list3>list4" + nl ok

func order alist, blist
     return strcmp(alist, blist)
