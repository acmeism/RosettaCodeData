cStr = read("unixdict.txt")
wordList = str2list(cStr)
num = 0

see "Odd words are:" + nl

for n = 1 to len(wordList)
    strWord = ""
    len = len(wordList[n])
    for m = 1 to len step 2
        strWord = strWord + wordList[n][m]
    next
    ind = find(wordList,strWord)
    if ind > 0  and len(strWord) > 4
       num = num + 1
       see "" + num + ". " + wordList[n] + " >> " + strWord + nl
    ok
next
