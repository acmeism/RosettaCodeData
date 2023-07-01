Topswops(Obj, n){
	R := []
	for i, val in obj{
		if (i <=n)
			res := val (A_Index=1?"":",") res
		else
			res .= "," val
	}
	Loop, Parse, res, `,
		R[A_Index]:= A_LoopField
	return R
}
