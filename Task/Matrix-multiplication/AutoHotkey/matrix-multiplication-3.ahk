A := [[1,2]
	, [3,4]
	, [5,6]
	, [7,8]]

B := [[1,2,3]
	, [4,5,6]]

if Res := Multiply_Matrix(A,B)
	MsgBox % Print(Res)
else
	MsgBox Error
return
Print(M){
	for i, row in M
		for j, col in row
			Res .= (A_Index=1?"":"`t") col (Mod(A_Index,M[1].MaxIndex())?"":"`n")
	return Trim(Res,"`n")
}
