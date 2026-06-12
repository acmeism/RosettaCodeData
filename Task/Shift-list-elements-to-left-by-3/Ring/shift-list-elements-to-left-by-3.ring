see "working..." + nl

shift = [1,2,3,4,5,6,7,8,9]
lenshift = len(shift)
shiftNew = list(lenshift)
nshift = 3
temp = list(nshift)

see "original list:" + nl
showArray(shift)
see nl + "Shifted left by 3:" + nl

for n = 1 to nshift
    temp[n] = shift[n]
next

for n = 1 to lenshift - nshift
    shiftNew[n] = shift[n+nshift]
next

for n = lenshift-nshift+1 to lenshift
    shiftNew[n] = temp[n-lenshift+nshift]
next

showArray(shiftNew)

see nl + "done..." + nl

func showArray(array)
     txt = "["
     for n = 1 to len(array)
         txt = txt + array[n] + ", "
     next
     txt = left(txt,len(txt)-2)
     txt = txt + "]"
     see txt
