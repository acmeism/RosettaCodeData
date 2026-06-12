result := "", cntr := 1
loop 1000{
	n := A_Index-1, sum := 0
	for i, v in StrSplit(n)
		sum += v
	if InStr(n, sum){
		result .= n (mod(cntr, 8)?"`t":"`n")
		if (++cntr = 50)
			break
	}
}
MsgBox % result
