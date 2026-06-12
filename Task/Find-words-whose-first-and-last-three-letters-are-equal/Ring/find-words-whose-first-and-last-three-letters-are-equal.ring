load "stdlib.ring"

cStr = read("unixdict.txt")
wordList = str2list(cStr)
num = 0

see "working..." + nl
see "Words are:" + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 6
       del(wordList,n)
    ok
next

for n = 1 to len(wordList)
    if left(wordList[n],3) = right(wordList[n],3)
       num = num + 1
       see "" + num + ". " + wordList[n] + nl
    ok
next

see "done..." + nl
