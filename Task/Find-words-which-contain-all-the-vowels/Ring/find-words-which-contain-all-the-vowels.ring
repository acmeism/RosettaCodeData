load "stdlib.ring"

cStr = read("unixdict.txt")
wordList = str2list(cStr)
num = 0
same = []
vowels = "aeiou"

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 11
       del(wordList,n)
    ok
next

for n = 1 to len(wordList)
    flag = 1
    str = wordList[n]
    stra = count(str,"a")
    stre = count(str,"e")
    stri = count(str,"i")
    stro = count(str,"o")
    stru = count(str,"u")
    strtmp = [stra,stre,stri,stro,stru]
    ln = len(strtmp)
    for m = 1 to ln
        if strtmp[m] != 1
           flag = 0
           exit
        ok
    next
    if flag = 1
       num = num + 1
       see "" + num + ". " + wordList[n] + nl
    ok
next

see "done..." + nl

func count(cString,dString)
     sum = 0
     while substr(cString,dString) > 0
           sum = sum + 1
           cString = substr(cString,substr(cString,dString)+len(string(sum)))
     end
     return sum
