see "working..." + nl
limit = 1000
list = []

for i = 1 to ceil(sqrt(limit)) step 2
    num = pow(i,2)
    if (num < 1000 and num > 99)
	add(list,num)
    ok
next

showArray(list)

see nl + "done..." + nl

func showArray(array)
     txt = ""
     see "["
     for n = 1 to len(array)
         txt = txt + array[n] + ","
     next
     txt = left(txt,len(txt)-1)
     txt = txt + "]"
     see txt
