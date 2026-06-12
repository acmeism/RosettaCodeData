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
    ind = substr(wordList[n],"e")
    if ind > 0
       str = substr(wordList[n],"e","i")
       indstr = find(wordList,str)
       if indstr > 0
          num = num + 1
          see "" + num + ". " + wordList[n] + " => " + str + nl
       ok
    ok
next

see "done..." + nl
