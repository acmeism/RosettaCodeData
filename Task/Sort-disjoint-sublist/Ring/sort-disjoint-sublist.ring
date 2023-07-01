aList = [7, 6, 5, 4, 3, 2, 1, 0]
indList = [7, 2, 8]
bList = []
for n = 1 to len(indList)
    add(bList,[indList[n],aList[indList[n]]])
next
bList1 = sort(bList,1)
bList2 = sort(bList,2)
for n = 1 to len(bList)
    aList[bList1[n][1]] = bList2[n][2]
next
showarray(aList)

func showarray vect
     svect = ""
     for n in vect
         svect += " " + n + ","
     next
     ? "[" + left(svect, len(svect) - 1) + "]"
