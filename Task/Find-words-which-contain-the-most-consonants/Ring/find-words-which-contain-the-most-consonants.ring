load "stdlib.ring"

cStr = read("unixdict.txt")
wordList = str2list(cStr)
consonants = []
result = []
num = 0

see "working..." + nl

ln = len(wordList)
for n = ln to 1 step -1
    if len(wordList[n]) < 11
       del(wordList,n)
    ok
next

for n = 1 to len(wordList)
    flag = 1
    numcon = 0
    str = wordList[n]
    for m = 1 to len(str) - 1
        for p = m+1 to len(str)
            if not isvowel(str[m]) and (str[m] = str[p])
               flag = 0
               exit 2
            ok
        next
    next
    if flag = 1
       add(consonants,wordList[n])
    ok
next

for n = 1 to len(consonants)
    con = 0
    str = consonants[n]
    for m = 1 to len(str)
        if not isvowel(str[m])
           con = con + 1
        ok
    next
    add(result,[consonants[n],con])
next

result = sortsecond(result)
result = reverse(result)

for n = 1 to len(result)
    see "" + n + ". " + result[n][1] + " " + result[n][2] + nl
next

see "done..." + nl

func sortsecond(alist)
     aList = sort(alist,2)
     for n=1 to len(alist)-1
         for m=n to len(aList)-1
             if alist[m+1][2] = alist[m][2] and strcmp(alist[m+1][1],alist[m][1]) > 0
                temp = alist[m+1]
                alist[m+1] = alist[m]
                alist[m] = temp
             ok
         next
     next
     return aList
