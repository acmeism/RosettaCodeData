see "working..." + nl

lenList = []
list = ["abcd","123456789","abcdef","1234567"]
for n = 1 to len(list)
    len = len(list[n])
    add(lenList,[len,n])
next

lenList = sort(lenList,1)
lenList = reverse(lenList)

see "Compare length of strings in descending order:" + nl
for n = 1 to len(lenList)
    see "" + list[lenList[n][2]] + " len = " + lenList[n][1] + nl
next
see "done..." + nl
