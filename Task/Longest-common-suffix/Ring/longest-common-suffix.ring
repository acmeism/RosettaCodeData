load "stdlib.ring"

pre = ["baabababc","baabc","bbbabc"]
len = len(pre)
lenList = list(len)
sub = list(len)

see "Input:" + nl
see pre

for n = 1 to len
    temp = pre[n]
    pre[n] = rever(temp)
next

for n = 1 to len
    lenList[n] = len(pre[n])
next

lenList = sort(lenList)
lenMax = lenList[1]

for m = 1 to lenMax
    check = 0
    sub1 = substr(pre[1],1,m)
    sub2 = substr(pre[2],1,m)
    sub3 = substr(pre[3],1,m)
    if sub1 = sub2 and sub2 = sub3
       check = 1
    ok
    if check = 1
       longest = m
    ok
next

longPrefix = substr(pre[1],1,longest)
longPrefix = rever(longPrefix)

see "Longest common suffix = " + longPrefix + nl

func rever(cstr)
     cStr2 = ""
     for x = len(cStr) to 1 step -1
         cStr2 = cStr2 + cStr[x]
     next
     return cStr2
