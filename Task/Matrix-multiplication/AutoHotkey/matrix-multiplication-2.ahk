Multiply_Matrix(A,B){
	if (A[1].Count() <> B.Count())
		return ["Dimension Error"]
	R := [], RRows := A.Count(), RCols:= b[1].Count()
	Loop, % RRows {
		RRow:=A_Index
		loop, % RCols {
			RCol:=A_Index, v := 0
			loop % A[1].Count()
				col := A_Index, v += A[RRow, col] * B[col, RCol]
			R[RRow,RCol] := v
		}
	}
	return R
}
