aList = [4,2,3,1]
see jortSort(aList) + nl

func jortSort array
     originalArray = array
     array = sort(array)
     for i= 1 to len(originalArray)
         if originalArray[i] != array[i] return false ok
     next
     return true
