# Project : Semordnilap

load "stdlib.ring"
nr = 0
num = 0
aList = file2list("C:\Ring\CalmoSoft\unixdict.txt")
for n = 1 to len(aList)
     bool = semordnilap(aList[n])
     if (bool > 0 and nr > n)
        num = num + 1
        if num % 31 = 0
           see aList[n] + " " + aList[nr] + nl
        ok
     ok
next
see "Total number of unique pairs = " + num + nl

func semordnilap(aString)
       bString = ""
       for i=len(aString) to 1 step -1
            bString = bString + aString[i]
       next
       nr = find(aList,bString)
       return nr
