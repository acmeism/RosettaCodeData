see "working..." + nl
see "Unique characters in each string are:" + nl
row = 0
str = ""
cList = []
uniqueChars = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]
lenChars = len(uniqueChars)

for n = 1 to lenChars
    str = str + uniqueChars[n]
next

for n = 1 to len(str)
    flag = 1
    for m = 1 to lenChars
        cnt = count(uniqueChars[m],str[n])
        if cnt != 1
           flag = 0
           exit
        ok
    next
    if flag = 1
       ind = find(cList,str[n])
       if ind = 0
          add(cList,str[n])
       ok
    ok
next
cList = sort(cList)
for n = 1 to len(cList)
    row = row + 1
    see "" + cList[n] + " "
next
see nl

see "Found " + row + " unique characters in each string" + nl
see "done..." + nl

func count(cString,dString)
     sum = 0
     while substr(cString,dString) > 0
           sum++
           cString = substr(cString,substr(cString,dString)+len(string(sum)))
     end
     return sum
