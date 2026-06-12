load "stdlib.ring"

st = "babaccd"
palList = []

for n = 1 to len(st)-1
    for m = n+1 to len(st)
        sub = substr(st,n,m-n)
        if ispalindrome(sub) and len(sub) > 1
           add(palList,[sub,len(sub)])
        ok
    next
next

palList = sort(palList,2)
palList = reverse(palList)
resList = []
add(resList,palList[1][1])

for n = 2 to len(palList)
    if palList[1][2] = palList[n][2]
       add(resList,palList[n][1])
    ok
next

see "Input: " + st + nl
see "Longest palindromic substrings:" + nl
see resList
