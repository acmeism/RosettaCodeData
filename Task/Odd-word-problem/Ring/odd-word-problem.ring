# Project : Odd word problem
# Date    : 2017/10/15
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

test = "what,is,the;meaning,of:life."
n1 = 1
testarr = []
testorigin = test
test = substr(test, ",", " ")
test = substr(test, ";", " ")
test = substr(test, ":", " ")
test = substr(test, ".", " ")

while true
      n2 = substring(test, " ", n1)
      n3 = substring(test, " ", n2 + 1)
      if n2>0 and n3>0
         strcut = substr(test, n2 + 1, n3 - n2)
         strcut = trim(strcut)
         if strcut != ""
            add(testarr, strcut)
            n1 = n3 + 1
         else
            exit
         ok
      ok
end

for n = 1 to len(testarr)
    strrev = revstr(testarr[n])
    testorigin = substr(testorigin, testarr[n], strrev)
next
see testorigin + nl

func Substring str,substr,n
     newstr=right(str,len(str)-n+1)
     nr = substr(newstr, substr)
     return n + nr -1

func revstr(cStr)
     cStr2 = ""
     for x = len(cStr) to 1 step -1
         cStr2 += cStr[x]
     next
     return cStr2
