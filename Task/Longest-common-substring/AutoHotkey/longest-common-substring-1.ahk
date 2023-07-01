LCS(a, b){
	x := i := 1
	while StrLen(x)	
		Loop % StrLen(a)
			IfInString, b, % x := SubStr(a, i:=StrLen(x)=1 ? i+1 : i, n:=StrLen(a)+1-A_Index)
				res := StrLen(res) > StrLen(x) ? res : x
	return res
}
