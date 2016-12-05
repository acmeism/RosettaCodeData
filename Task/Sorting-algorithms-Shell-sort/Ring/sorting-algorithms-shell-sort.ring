aList = [-12, 3, 0, 4, 7, 4, 8, -5, 9]
shellSort(aList)
for i=1 to len(aList)
    see "" + aList[i] + " "
next

func shellSort a
     inc = ceil( len(a) / 2 )
     while inc > 0
           for i = inc to len(a)
               tmp = a[i]
               j = i
               while j > inc and a[j-inc] > tmp
                     a[j] = a[j-inc]
                     j = j - inc
               end
               a[j] = tmp
           next
           inc = floor( 0.5 + inc / 2.2 )
     end
     return a
