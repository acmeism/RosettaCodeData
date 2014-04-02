Multiply_Matrix(A,B){
	if (A[1].MaxIndex() <> B.MaxIndex())
		return
	RCols := A[1].MaxIndex()>B[1].MaxIndex()?A[1].MaxIndex():B[1].MaxIndex()
	RRows := A.MaxIndex()>B.MaxIndex()?A.MaxIndex():B.MaxIndex(),	 R := []
	Loop, % RRows {
		RRow:=A_Index
		loop, % RCols {
			RCol:=A_Index,			v := 0
			loop % A[1].MaxIndex()
				col := A_Index,		v += A[RRow, col] * B[col,RCol]
			R[RRow,RCol] := v
		}
	}
	return R
}
