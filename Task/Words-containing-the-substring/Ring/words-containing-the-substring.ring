cStr = read("unixdict.txt")
wordList = str2list(cStr)
num = 0
the = "the"

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 12
       del(wordList,n)
    ok
next

see "Words containing "the" substring:" + nl

for n = 1 to len(wordList)
    ind = substr(wordList[n],the)
    if ind > 0
       num = num +1
       see "" + num + ". " + wordList[n] + nl
    ok
next

see "done..." + nl
