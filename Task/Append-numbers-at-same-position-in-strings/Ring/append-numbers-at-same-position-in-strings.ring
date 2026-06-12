load "stdlib.ring"
list1 = [1,2,3,4,5,6,7,8,9]
list2 = [10,11,12,13,14,15,16,17,18]
list3 = [19,20,21,22,23,24,25,26,27]
list = []

for n = 1 to len(list1)
    str1 = string(list1[n])
    str2 = string(list2[n])
    str3 = string(list3[n])
    str = str1 + str2 + str3
    add(list,str)
next

showArray(list)

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
