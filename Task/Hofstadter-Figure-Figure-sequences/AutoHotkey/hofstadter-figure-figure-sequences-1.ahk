R(n){
	if n=1
		return 1
	return R(n-1) + S(n-1)
}

S(n){
	static ObjR:=[]
	if n=1
		return 2
	ObjS:=[]
	loop, % n
		ObjR[R(A_Index)] := true
	loop, % n-1
		ObjS[S(A_Index)] := true
	Loop
		if !(ObjR[A_Index]||ObjS[A_Index])
			return A_index
}
