size = 27
aList = []
hailstone(size)

func hailstone n
     add(aList,n)
     while n != 1
           if n % 2 = 0  n = n / 2
           else n = 3 * n + 1 ok
           add(aList, n)
     end
     see "first 4 elements : "
     for i = 1 to 4
         see "" + aList[i]  + " "
     next
     see nl
     see "last 4 elements : "
     for i = len(aList) - 3 to len(aList)
         see "" + aList[i] + " "
     next
