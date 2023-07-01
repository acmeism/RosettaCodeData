RangeConsolidation(arr){
	arr1 := [],	arr2 := [], result := []
	
	for i, obj in arr
		arr1[i,1] := min(arr[i]*), arr1[i,2] := max(arr[i]*)	; sort each range individually
	
	for i, obj in arr1
		if (obj.2 > arr2[obj.1])
			arr2[obj.1] := obj.2				; creates helper array sorted by range
	
	i := 1
	for start, stop in arr2
		if (i = 1) || (start > result[i-1, 2])			; first or non overlapping range
			result[i, 1] := start, result[i, 2] := stop, i++
		else							; overlapping range
			result[i-1, 2] := stop > result[i-1, 2] ? stop : result[i-1, 2]
	return result
}
