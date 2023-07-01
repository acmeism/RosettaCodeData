aList = [1,2,3,4,5]
see sumOfSquares(aList)

func sumOfSquares sos
sumOfSquares = 0
for i=1 to len(sos)
    sumOfSquares = sumOfSquares + pow(sos[i],2)
next
return sumOfSquares
