cStr = read("unixdict.txt")
wordList = str2list(cStr)
num = 0

see "ABC words are:" + nl

for n = 1 to len(wordList)
    bool1 = substr(wordList[n],"a")
    bool2 = substr(wordList[n],"b")
    bool3 = substr(wordList[n],"c")
    bool4 = bool1 > 0 and bool2 > 0 and bool3 > 0
    bool5 = bool2 > bool1 and bool3 > bool2
    if bool4 = 1 and bool5 = 1
       num = num + 1
       see "" + num + ". " + wordList[n] + nl
    ok
next
