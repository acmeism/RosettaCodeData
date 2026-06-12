load "stdlib.ring"

cStr = read("unixdict.txt")
wordList = str2list(cStr)
sum = 0
see "working..." + nl + nl

for n = 1 to len(wordList)
    wordOdd = ""
    wordEven = ""
    for m = 1 to len(wordList[n]) step 2
        wordOdd = wordOdd + wordList[n][m]
    next
    for m = 2 to len(wordList[n]) step 2
        wordEven = wordEven + wordList[n][m]
    next
    indOdd = find(wordList,wordOdd)
    indEven = find(wordList,wordEven)
    if indOdd > 0 and indEven > 0 and len(wordList[indOdd]) > 2 and len(wordList[indEven]) > 2
       sum = sum + 1
       see "" + sum + ". "
       see "word = " + wordList[n] + nl
       see "wordOdd = " + wordList[indOdd] + nl
       see "wordEven = " + wordList[indEven] + nl + nl
    ok
next
see "done..." + nl
