aList = "[[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]"
bList = ""
cList = ""
for n=1 to len(aList)
    if ascii(aList[n]) >= 48 and  ascii(aList[n]) <= 57
    bList = bList + ", " + aList[n] ok
next
cList = substr(bList,3,Len(bList)-2)
dList = "[" + cList + "]"
see dList + nl
