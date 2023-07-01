num := 0
loop 7
	output .= A_Index-1 " : " ThueMorse(num, A_Index-1) "`n"
MsgBox % output
