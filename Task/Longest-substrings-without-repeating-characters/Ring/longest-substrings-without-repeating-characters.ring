see "working..." + nl
see "Longest substrings without repeating characters are:" + nl
str = "xyzyabcybdfd"
see "Input: " + str + nl
lenStr = len(str)
strOk = []
lenOk = 0

for n = 1 to lenStr
    for m = 1 to lenStr-n+1
        temp = substr(str,n,m)
        add(strOk,temp)
    next
next

for n = len(strOk) to 1 step -1
    if len(strOK[n]) = 1
       del(strOK,n)
    ok
next

for n = 1 to len(strOK)
    for m = 1 to len(strOK)-1
        if len(strOK[m+1]) > len(strOK[m])
           temp = strOK[m]
           strOK[m] = strOK[m+1]
           strOK[m+1] = temp
        ok
    next
next

for n = 1 to len(strOK)
    flag = 1
    for m = 1 to len(strOK[n])
        for p = m+1 to len(strOK[n])
            if strOK[n][m] = strOK[n][p]
               flag = 0
               exit
            ok
        next
    next
    if flag = 1
       if len(strOK[n]) >= lenOk
          see "len = " + len(strOK[n]) + " : " + strOK[n] + nl
          lenOK = len(strOK[n])
       ok
    ok
next

see "done..." + nl
