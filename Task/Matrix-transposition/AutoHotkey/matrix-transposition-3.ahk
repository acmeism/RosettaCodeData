Matrix := [[1,2,3],[4,5,6],[7,8,9],[10,11,12]]
MsgBox % 	""
		. "Original Matrix :`n" 		Print(Matrix)
		. "`nTransposed Matrix :`n" 	Print(Transpose(Matrix))

Print(M){
	for i, row in M
		for j, col in row
			Res .= (A_Index=1?"":"`t") col (Mod(A_Index,M[1].MaxIndex())?"":"`n")
	return Trim(Res,"`n")
}
