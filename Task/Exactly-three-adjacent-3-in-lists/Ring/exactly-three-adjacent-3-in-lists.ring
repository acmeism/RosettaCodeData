see "working..." + nl

list = List(5)
list[1] = [9,3,3,3,2,1,7,8,5]
list[2] = [5,2,9,3,3,7,8,4,1]
list[3] = [1,4,3,6,7,3,8,3,2]
list[4] = [1,2,3,4,5,6,7,8,9]
list[5] = [4,6,8,7,2,3,3,3,1]

for n = 1 to 5
    good = 0
    cnt = 0
    len = len(list[n])
    for p = 1 to len
        if list[n][p] = 3
           good++
        ok
    next
    if good = 3
       for m = 1 to len-2
           if list[n][m] = 3 and list[n][m+1] = 3 and list[n][m+2] = 3
              cnt++
           ok
       next
    ok
    showarray(list[n])
    if cnt = 1
       see " > " + "true" + nl
    else
       see " > " + "false" + nl
    ok
next

see "done..." + nl

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
