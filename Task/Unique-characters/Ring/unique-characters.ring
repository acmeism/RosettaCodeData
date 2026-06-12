see "working..." + nl
see "Unique characters are:" + nl
row = 0
str = ""
cList = []
uniqueChars = ["133252abcdeeffd", "a6789798st","yxcdfgxcyz"]
for n = 1 to len(uniqueChars)
    str = str + uniqueChars[n]
next
for n = 1 to len(str)
    ind = count(str,str[n])
    if ind = 1
       row = row + 1
       add(cList,str[n])
    ok
next
cList = sort(cList)
for n = 1 to len(cList)
    see "" + cList[n] + " "
next
see nl

see "Found " + row + " unique characters" + nl
see "done..." + nl

func count(cString,dString)
     sum = 0
     while substr(cString,dString) > 0
           sum++
           cString = substr(cString,substr(cString,dString)+len(string(sum)))
     end
     return sum
