aList = [ 5, 6, 1, 2, 9, 14, 15, 7, 8, 97]
gnomeSort(aList)
for i=1 to len(aList)
    see "" + aList[i] + " "
next

func gnomeSort a
     i = 2
     j = 3
     while i < len(a)
           if a[i-1] <= a[i]
              i = j
              j = j + 1
           else
              temp = a[i-1]
              a[i-1] = a[i]
              a[i] = temp
              i = i - 1
              if i = 1
                 i = j
                 j = j + 1 ok ok end
