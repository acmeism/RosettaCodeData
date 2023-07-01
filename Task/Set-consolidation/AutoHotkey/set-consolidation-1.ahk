SetConsolidation(sets){
	arr2 := [] , arr3 := [] , arr4 := [] , arr5 := [], result:=[]
	; sort each set individually
	for i, obj in sets
	{
		arr1 := []
		for j, v in obj
			arr1[v] := true
		arr2.push(arr1)
	}
	
	; sort by set's first item
	for i, obj in arr2
		for k, v in obj
		{
			arr3[k . i] := obj
			break
		}
	
	; use numerical index
	for k, obj in arr3
		arr4[A_Index] := obj
	
	j := 1
	for i, obj in arr4
	{
		common := false
		for k, v in obj
			if arr5[j-1].HasKey(k)
			{
				common := true
				break
			}
		
		if common
			for k, v in obj
				arr5[j-1, k] := true
		else
			arr5[j] := obj, j++
	}
	; clean up
	for i, obj in arr5
		for k , v in obj
			result[i, A_Index] := k
	return result
}
