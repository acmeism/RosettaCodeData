Next_highest_int(num){
	Arr := []
	for i, v in permute(num)
		Arr[v] := true
	for n, v in Arr
		if found
			return n
		else if (n = num)
			found := true
	return 0
}
permute(str, k:=0, l:=1){
	static res:=[]
	r := StrLen(str)
	k := k ? k : r
	if (l = r)
		return SubStr(str, 1, k)
	i := l
	while (i <= r){
		str := swap(str, l, i)
		x := permute(str, k, l+1)
		if (x<>"")
			res.push(x)
		str := swap(str, l, i++)
	}
	if (l=1)
		return x:=res, res := []
}
swap(str, l, i){
	x := StrSplit(str), var := x[l], x[l] := x[i], x[i] := var
	Loop, % x.count()
		res .= x[A_Index]
	return res
}
