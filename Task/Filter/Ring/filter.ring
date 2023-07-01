aList = [1, 2, 3, 4, 5, 6]
bArray = list(3)
see evenSelect(aList)

func evenSelect aArray
i = 0
for n = 1 to len(aArray)
    if (aArray[n] % 2) = 0
       i = i + 1
       bArray[i] = aArray[n] ok
next
return bArray
