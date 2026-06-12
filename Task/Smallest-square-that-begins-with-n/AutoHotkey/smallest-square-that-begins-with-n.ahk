loop 49
	result .= SS(A_Index) (Mod(A_Index,7)?"`t":"`n")
MsgBox % result
return

SS(n) {
	if (n < 1)
		return
	loop{
		sq := a_index**2
		while (sq > n)
			sq := Format("{:d}", sq/10)
		if (sq = n)
			return a_index**2
	}
}
