pn := 0, result := ""
loop 50 {
	n := SubStr("       " ((A_Index-1)**3 + pn), -6)
	result .= n (Mod(A_Index, 10)?"`t":"`n")
	pn := n
}
MsgBox % result
