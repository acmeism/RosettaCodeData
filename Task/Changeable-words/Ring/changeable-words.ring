cStr = read("unixdict.txt")
wordList = str2list(cStr)
num = 0

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 12
       del(wordList,n)
    ok
next

see "Changable words are:" + nl

for n = 1 to len(wordList)
    len = len(wordList[n])
    for m = 1 to len
        abcList = "abcdefghijklmnopqrstuvwxyz"
        for abc in abcList
            str1 = left(wordList[n],m-1)
            str2 = abc
            str3 = right(wordList[n],len-m)
            tempWord = str1 + str2 + str3
            ind = find(wordList,tempWord)
            bool = (ind > 0) and (wordList[n][m] != abc)
            if bool = 1
               num = num + 1
               see "" + num + ". " + wordList[n] + " >> " + tempWord + nl
            ok
        next
    next
next

see "done..." + nl
