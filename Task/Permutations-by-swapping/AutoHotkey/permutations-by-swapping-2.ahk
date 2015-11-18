for each, line in StrSplit(Permutations_By_Swapping(1234), "`n")
	result .= line "`tSign: " (mod(A_Index,2)? 1 : -1) "`n"
MsgBox, 262144, , % result
return
