aString = "[[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]"
bString = ""
cString = ""
for n=1 to len(aString)
    if ascii(aString[n]) >= 48 and  ascii(aString[n]) <= 57
       bString = bString + ", " + aString[n]
    ok
next
cString = substr(bString,3,Len(bString)-2)
cString = '"' + cString + '"'
see cString + nl
