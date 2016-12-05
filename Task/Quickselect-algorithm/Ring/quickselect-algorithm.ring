aList = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
see partition(aList, 9, 4, 2) + nl

func partition list, left, right, pivotIndex
     pivotValue = list[pivotIndex]
     temp = list[pivotIndex]
     list[pivotIndex] = list[right]
     list[right]  = temp
     storeIndex = left
     for i = left to right-1
         if list[i] < pivotValue
            temp = list[storeIndex]
            list[storeIndex] = list[i]
            list[i] = temp
            storeIndex++ ok
         temp = list[right]
         list[right] = list[storeIndex]
         list[storeIndex] = temp
     next
     return storeIndex
