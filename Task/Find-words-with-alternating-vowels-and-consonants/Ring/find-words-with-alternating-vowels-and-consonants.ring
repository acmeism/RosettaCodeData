cStr = read("unixdict.txt")
wordList = str2list(cStr)
words = []
num = 0
vowels = "aeiou"
consonants = "bcdfghjklmnpqrstvwxyz"

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 10
       del(wordList,n)
    ok
next

see "Words are:" + nl + nl

for n = 1 to len(wordList)
    cflag = 0
    vflag = 0
    len = len(wordList[n])
    for m = 1 to len
        if m % 2 = 1
           cons = substr(consonants,wordList[n][m])
           if cons > 0
              cflag = 1
           else
              cflag = 0
              exit
           ok
        ok
        if m % 2 = 0
           cons = substr(vowels,wordList[n][m])
           if cons > 0
              vflag = 1
           else
              vflag = 0
              exit
           ok
        ok
    next
    if cflag = 1 and vflag = 1
       add(words,wordList[n])
    ok
next

for n = 1 to len(wordList)
    cflag = 0
    vflag = 0
    len = len(wordList[n])
    for m = 1 to len
        if m % 2 = 1
           cons = substr(vowels,wordList[n][m])
           if cons > 0
              cflag = 1
           else
              cflag = 0
              exit
           ok
        ok
        if m % 2 = 0
           cons = substr(consonants,wordList[n][m])
           if cons > 0
              vflag = 1
           else
              vflag = 0
              exit
           ok
        ok
    next
    if cflag = 1 and vflag = 1
       add(words,wordList[n])
    ok
next

words = sort(words)

for n = 1 to len(words)
    see "" + n + ". " + words[n] + nl
next

see "done..." + nl
