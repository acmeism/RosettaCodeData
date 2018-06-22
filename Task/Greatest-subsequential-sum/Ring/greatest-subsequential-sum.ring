# Project : Greatest subsequential sum
# Date    : 2017/09/26
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

aList1 = [0, 1, 2, -3, 3, -1, 0, -4, 0, -1, -4, 2]
see "[0, 1, 2, -3, 3, -1, 0, -4, 0, -1, -4, 2]  -> " + sum(aList1) + nl
aList2 = [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
see "[-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1] -> " + sum(aList2) + nl
aList3 = [-1, -2, -3, -4, -5]
see "[-1, -2, -3, -4, -5] -> " + sum(aList3) + nl
aList4 = []
see "[] - > " + sum(aList4) + nl

func sum aList
     sumold = []
     sumnew = []
     snew = 0
     flag = 0
     if len(aList) = 0
        return 0
     ok
     for s=1 to len(aList)
         if aList[s] > -1
            flag = 1
         ok
     next
     if flag = 0
        return "[]"
     ok
     for n=1 to len(aList)
         sumold = []
         sold = 0
         for m=n to len(aList)
             add(sumold, aList[m])
             sold = sold + aList[m]
             if sold > snew
                snew = sold
                sumnew = sumold
             ok
         next
     next
     return showarray(sumnew)

func showarray(a)
     conv = "["
     for i = 1 to len(a)
         conv = conv + string(a[i]) + ", "
     next
     conv = left(conv, len(conv) - 2) + "]"
     return conv
