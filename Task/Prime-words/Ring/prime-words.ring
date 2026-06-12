load "stdlib.ring"

cStr = read("unixdict.txt")
wordList = str2list(cStr)
Words = []

for n = 1 to len(wordList)
    num = 0
    len = len(wordList[n])
    for m = 1 to len
        asc = ascii(wordList[n][m])
        if isprime(asc)
           num = num + 1
        else
           exit
        ok
    next
    if num = len
       add(Words,wordList[n])
    ok
next

see "Prime words are:" + nl
see Words
