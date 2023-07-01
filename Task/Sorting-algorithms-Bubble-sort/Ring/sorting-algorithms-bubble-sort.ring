bubbleList = [4,2,1,3]
flag = 0
bubbleSort(bubbleList)
see bubbleList

func bubbleSort A
     n = len(A)
     while flag = 0
           flag = 1
           for i = 1 to n-1
               if A[i] > A[i+1]
                  temp = A[i]
                  A[i] = A[i+1]
                  A[i+1] = temp
                  flag = 0
                ok
            next
      end
