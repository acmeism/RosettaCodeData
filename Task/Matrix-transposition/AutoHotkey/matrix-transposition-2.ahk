Transpose(M){
	R := []
	for i, row in M
		for j, col in row
			R[j,i] := col
	return R
}
