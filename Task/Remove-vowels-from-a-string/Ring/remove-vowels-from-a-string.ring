load "stdlib.ring"
str = "Ring Programming Language"
see "Input : " + str + nl
for n = 1 to len(str)
    if isVowel(str[n])
       str = substr(str,str[n],"")
    ok
next
see "String without vowels: " + str + nl
