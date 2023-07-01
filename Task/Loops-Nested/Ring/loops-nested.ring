size = 5
array = newlist(size,size)
for row = 1 to size
    for col = 1 to size
        array[row][col] = random(19) + 1
    next
next

for row = 1 to size
    for col = 1 to size
        see "row " + row + " col " + col + "value : " + array[row][col] + nl
        if array[row][col] = 20 exit for row ok
    next
next

func newlist x, y
     if isstring(x) x=0+x ok
     if isstring(y) y=0+y ok
     aList = list(x)
     for t in aList
         t = list(y)
     next
     return aList
