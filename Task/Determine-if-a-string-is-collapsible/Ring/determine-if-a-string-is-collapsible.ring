load "stdlib.ring"

see "working..." + nl + nl
str = ["The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
       "I never give 'em hell, I just tell the truth, and they think it's hell.",
       "..1111111111111111111111111111111111111111111111111111111111111117777888"]
strsave = str
for n = 1 to len(str)
    for m = 1 to len(str[n])-1
        if substr(str[n],m,1) = substr(str[n],m+1,1)
           str[n] = left(str[n],m) + right(str[n],len(str[n])-m-1)
           for p = len(str[n]) to 2 step -1
               if substr(str[n],p,1) = substr(str[n],p-1,1)
                  str[n] = left(str[n],p-1) + right(str[n],len(str[n])-p)
               ok
           next
        ok
     next
next

for n = 1 to len(str)
    see "" + len(strsave[n]) + "«««" + strsave[n] + "»»»" + nl
    see "" + len(str[n]) + "«««" + str[n] + "»»»" + nl + nl
next

see "done..." + nl
