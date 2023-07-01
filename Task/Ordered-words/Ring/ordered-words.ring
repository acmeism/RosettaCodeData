load "stdlib.ring"


cStr = read("unixdict.txt")
wordList = str2list(cStr)
sum = 0
sortList = []

see "working..." + nl + nl

for n = 1 to len(wordList)
    num = 0
    len = len(wordList[n])-1
    for m = 1 to len
        asc1 = ascii(wordList[n][m])
        asc2 = ascii(wordList[n][m+1])
        if asc1 <= asc2
           num = num + 1
        ok
    next
    if num = len
       sum = sum + 1
       add(sortList,[wordList[n],len])
    ok
next

sortList = sort(sortList,2)
sortList = reverse(sortList)
endList = []

len = sortList[1][2]

for n = 1 to len(sortList)
    if sortList[n][2] = len
       add(endList,sortList[n][1])
    else
       exit
    ok
next

endList = sort(endList)
see endList

see nl + "done..." + nl
