matrx :=[[1,3,7,8,10]
		,[2,4,16,14,4]
		,[3,1,9,18,11]
		,[12,14,17,18,20]
		,[7,1,3,9,5]]
sumA := sumB := sumD :=  sumAll := 0
for r, obj in matrx
	for c, val in obj
		sumAll += val
		,sumA += r<c ? val : 0
		,sumB += r>c ? val : 0
		,sumD += r=c ? val : 0

MsgBox % result := "sum above diagonal = " sumA
. "`nsum below diagonal = " sumB
. "`nsum on diagonal = " sumD
. "`nsum all = " sumAll
