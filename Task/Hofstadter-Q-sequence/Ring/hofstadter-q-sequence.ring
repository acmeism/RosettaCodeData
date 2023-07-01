n = 20
aList = list(n)
aList[1] = 1
aList[2] = 1
for i = 1 to n
    if i >= 3 aList[i] = ( aList[i - aList[i-1]] + aList[i - aList[i-2]] ) ok
    if i <= 20 see "n = " + string(i) + " : "+ aList[i] + nl ok
next
