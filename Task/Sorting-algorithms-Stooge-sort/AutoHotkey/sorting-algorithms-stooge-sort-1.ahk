StoogeSort(L, i:=1, j:=""){
	if !j
		j := L.MaxIndex()
	if (L[j] < L[i]){
		temp := L[i]
		L[i] := L[j]
		L[j] := temp
	}
	if (j - i > 1){
		t := floor((j - i + 1)/3)
		StoogeSort(L, i, j-t)
		StoogeSort(L, i+t, j)
		StoogeSort(L, i, j-t)
	}
	return L
}
