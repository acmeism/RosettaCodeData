aVector = [2, 3, 5]
bVector = [4, 2, 1]
sum = 0
see dotProduct(aVector, bVector)

func dotProduct cVector, dVector
     for n = 1 to len(aVector)
         sum = sum + cVector[n] * dVector[n]
     next
     return sum
