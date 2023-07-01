pancakeList = [6, 7, 8, 9, 2, 5, 3, 4, 1]
flag = 0
see "Before :" + nl
for n = 1 to len(pancakeList)
    see pancakeList[n] + " "
next
see nl

pancakeSort(pancakeList)

see "After :" + nl
for n = 1 to len(pancakeList)
    see pancakeList[n] + " "
next
see nl

func pancakeSort A
     n = len(A)
     while flag =  0
           flag = 1
           for i = 1 to n-1
               if A[i] < A[i+1]
                  temp = A[i]
                  A[i] = A[i+1]
                  A [i+1] = temp
                  flag = 0 ok
           next
     end
     return A
