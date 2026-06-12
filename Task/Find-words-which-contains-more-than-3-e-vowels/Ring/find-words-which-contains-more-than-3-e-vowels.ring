load "stdlib.ring"

cStr = read("unixdict.txt")
wordList = str2list(cStr)
char = list(9)
nextwords = []
nr = 0
num = 0

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 6
       del(wordList,n)
    ok
next

see "Words are:" + nl

for n = 1 to len(wordList)
    num = 0
    flag = 1
    for m = 1 to len(wordList[n])
        if isvowel(wordList[n][m])
           if wordList[n][m] != "e"
              flag = 0
              exit
           else
              num = num + 1
           ok
        ok
    next
    if flag = 1 and num > 3
       nr = nr + 1
       see "" + nr + ". " + wordList[n] + nl
    ok
next

see "done..." + nl
