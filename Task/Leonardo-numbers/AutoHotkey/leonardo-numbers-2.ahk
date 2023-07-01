output := "1st 25 Leonardo numbers, starting at L(0).`n"
loop, 25
	output .= Leonardo(A_Index-1) " "
output .= "`n`n1st 25 Leonardo numbers, specifying 0 and 1 for L(0) and L(1), and 0 for the add number:`n"
loop, 25
	output .= Leonardo(A_Index-1, 0, 1, 0) " "
MsgBox % output
return
