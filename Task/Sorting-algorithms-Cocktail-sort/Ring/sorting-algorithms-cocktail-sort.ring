aList = [ 5, 6, 1, 2, 9, 14, 2, 15, 6, 7, 8, 97]
flag = 0
cocktailSort(aList)
for i=1 to len(aList)
    see "" + aList[i] + " "
next

func cocktailSort A
       n = len(A)
       while flag =  0
             flag = 1
             for i = 1 to n-1
                 if A[i] > A[i+1]
                    temp = A[i]
                    A[i] = A[i+1]
                    A [i+1] = temp
                    flag = 0
                    ok
             next
       end
