# Project : Set
# Date    : 2018/03/26
# Author : Gal Zsolt [~ CalmoSoft ~]
# Email   : <calmosoft@gmail.com>

arr = ["apple", "banana", "cherry", "date", "elderberry", "fig", "grape"]
for n = 1 to 25
     add(arr,"")
next
seta = "1010101"
see "Set A: " + arrset(arr,seta) + nl
setb = "0111110"
see "Set B: " + arrset(arr,setb) + nl
elementm = "0000010"
see "Element M: " + arrset(arr,elementm) + nl

temp = arrsetinsec(elementm,seta)
if len(temp) > 0
   see "M is an element of set A" + nl
else
   see "M is not an element of set A" + nl
ok
temp = arrsetinsec(elementm,setb)
if len(temp) > 0
   see "M is an element of set B" + nl
else
   see "M is not an element of set B" + nl
ok

see "The union of A and B is: "
see arrsetunion(seta,setb) + nl
see "The intersection of A and B is: "
see  arrsetinsec(seta,setb) + nl
see "The difference of A and B is: "
see arrsetnot(seta,setb) + nl

flag = arrsetsub(seta,setb)
if flag = 1
   see "Set A is a subset of set B" + nl
else
   see "Set A is not a subset of set B" + nl
ok
if seta = setb
   see "Set A is equal to set B" + nl
else
   see "Set A is not equal to set B" + nl
ok

func arrset(arr,set)
       o = ""
       for i = 1 to 7
            if set[i] = "1"
                o = o + arr[i] + ", "
            ok
       next
       return left(o,len(o)-2)

func arrsetunion(seta,setb)
       o = ""
       union = list(len(seta))
       for n = 1 to len(seta)
            if seta[n] = "1" or setb[n] = "1"
               union[n] = "1"
            else
               union[n] = "0"
            ok
       next
       for i = 1 to len(union)
            if union[i] = "1"
                o = o + arr[i] + ", "
            ok
       next
       return o

func arrsetinsec(setc,setd)
       o = ""
       union = list(len(setc))
       for n = 1 to len(setc)
            if setc[n] = "1" and setd[n] = "1"
               union[n] = "1"
            else
               union[n] = "0"
            ok
       next
       for i = 1 to len(union)
            if union[i] = "1"
                o = o + arr[i] + ", "
            ok
       next
       return o

func arrsetnot(seta,setb)
       o = ""
       union = list(len(seta))
       for n = 1 to len(seta)
            if seta[n] = "1" and setb[n] = "0"
               union[n] = "1"
            else
               union[n] = "0"
            ok
       next
       for i = 1 to len(union)
            if union[i] = "1"
                o = o + arr[i] + ", "
            ok
       next
       return o

func arrsetsub(setc,setd)
       flag = 1
       for n = 1 to len(setc)
            if setc[n] = "1" and setd[n] = "0"
               flag = 0
            ok
       next
       return flag
