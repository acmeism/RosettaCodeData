Next_highest_int(num){
	Loop % StrLen(num){
		i := A_Index
		if (left := SubStr(num, 0-i, 1)) < (right := SubStr(num, 1-i, 1))
			break
	}
	if !(left < right)
		return 0	
	x := StrLen(num) - i
	num := swap(num, x, x+1)
	Rdigits := rSort(SubStr(num, 1-i))
	return SubStr(num,1, StrLen(num)-StrLen(Rdigits)) . Rdigits
}
swap(str, l, i){
	x := StrSplit(str), var := x[l], x[l] := x[i], x[i] := var
	Loop, % x.count()
		res .= x[A_Index]
	return res
}
rSort(num){
	Arr := []
	for i, v in StrSplit(num)
		Arr[v, i] := v
	for i, obj in Arr
		for k, v in obj
			res .= v
	return res
}
