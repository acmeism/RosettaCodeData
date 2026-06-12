cStr = read("unixdict.txt")
wordList = str2list(cStr)
char = list(9)
nextwords = []
num = 0

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 9
       del(wordList,n)
    ok
next

see "New words are:" + nl

for n = 1 to len(wordList)-8
    for m = 1 to 9
        char[m] = substr(wordList[n+m-1],m,1)
    next
    str = ""
    for p = 1 to 9
        str = str + char[p]
    next
    ind = find(wordList,str)
    if ind > 0
       add(nextwords,wordList[ind])
    ok
next

nextwords = sort(nextwords)
for n = len(nextwords) to 2 step -1
    if nextwords[n] = nextwords[n-1]
       del(nextwords,n)
    ok
next

for n = 1 to len(nextwords)
    see "" + n + ". " + nextwords[n] + nl
next

see "done..." + nl
