aList = [4, 65, 2, 99, 83, 782, 1]
see countingSort(aList, 1, 782)

func countingSort f, min, max
     count = list(max-min+1)
     for i = min to max
         count[i] = 0
     next

     for i = 1 to len(f)
         count[ f[i] ] = count[ f[i] ] + 1
     next

     z = 1
     for i = min to max
         while count[i] > 0
               f[z] = i
               z = z + 1
               count[i] = count[i] - 1
         end
     next
     return f
