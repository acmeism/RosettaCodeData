see "working..." + nl
see "Sort the letters of string in alphabitical order:" + nl
str = "forever ring programming language"
see "Input: " + str + nl

for n = 1 to len(str)-1
    for m = n+1 to len(str)
        if ascii(str[n]) > ascii(str[m])
           temp = str[n]
           str[n] = str[m]
           str[m] = temp
        ok
    next
next

str = substr(str," ","")
see "Output: " + str + nl
see "done..." + nl
