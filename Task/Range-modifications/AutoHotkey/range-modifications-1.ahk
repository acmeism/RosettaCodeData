RangeModifications(arr, Modify, v){
	global steps							; optional line to track examples steps
	if (Modify = "add")
		arr.push([v, v])
	if (Modify = "remove")
		for i, obj in arr
			if (v >= (start := obj.1)) && (v <= (stop := obj.2))
			{
				arr.RemoveAt(i)
				if (start = v) && (v = stop)
					continue
				arr.push(start < v ? [start, v-1] : [v+1, v+1])
				arr.push(v < stop  ? [v+1, stop]  : [v-1, v-1])
			}
	result := RangeConsolidation(arr)
	steps .= Modify "`t" v "`t:`t" obj2string(result) "`n"		; optional line to track examples steps
	return result
}
RangeConsolidation(arr){ ;-) borrowed my own function from http://www.rosettacode.org/wiki/Range_consolidation#AutoHotkey
	arr1 := [],	arr2 := [], result := []
	
	for i, obj in arr
		arr1[i,1] := min(arr[i]*), arr1[i,2] := max(arr[i]*)	; sort each range individually
	
	for i, obj in arr1
		if (obj.2 > arr2[obj.1])
			arr2[obj.1] := obj.2				; creates helper array sorted by range
	
	i := 1
	for start, stop in arr2
		if (i = 1) || (start > result[i-1, 2] + 1)		; first or non overlapping range
			result[i, 1] := start, result[i, 2] := stop, i++
		else							; overlapping range
			result[i-1, 2] := stop > result[i-1, 2] ? stop : result[i-1, 2]
	return result
}
obj2string(arr){
	for i, obj in arr
		str .= obj.1 "-" obj.2 ","
	return Trim(str, ",")
}
string2obj(str){
	arr := []
	for i, v in StrSplit(str, ",")
		x := StrSplit(v, "-"), arr.push([x.1, x.2])
	return arr
}
