load "stdlib.ring"
aList = file2list("C:\Ring\unixdict.txt")
for m = 1 to 10
    nr = random(len(aList)-1) + 1
    bool = semordnilap(aList[nr])
    see aList[nr] + nl
    if bool = 0 see "is palindrome" + nl + nl
    else see "is semordnilap" + nl + nl ok
next

func semordnilap aString
     bString = ""
     for i=len(aString) to 1 step -1
         bString = bString + aString[i]
     next
     see aString
     if aString = bString return 0 else return 1 ok
