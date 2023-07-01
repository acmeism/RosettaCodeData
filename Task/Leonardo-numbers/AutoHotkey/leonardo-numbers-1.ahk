Leonardo(n, L0:=1, L1:=1, step:=1){
	if n=0
		return L0
	if n=1
		return L1
	return Leonardo(n-1, L0, L1, step) + Leonardo(n-2, L0, L1, step) + step
}
