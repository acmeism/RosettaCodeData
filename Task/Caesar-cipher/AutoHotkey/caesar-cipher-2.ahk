Caesar(string, n){
	Loop Parse, string
	{
		If (Asc(A_LoopField) >= Asc("A") and Asc(A_LoopField) <= Asc("Z"))
			out .= Chr(Mod(Asc(A_LoopField)-Asc("A")+n,26)+Asc("A"))
		Else If (Asc(A_LoopField) >= Asc("a") and Asc(A_LoopField) <= Asc("z"))
			out .= Chr(Mod(Asc(A_LoopField)-Asc("a")+n,26)+Asc("a"))
		Else out .= A_LoopField
	}
	return out
}

MsgBox % Caesar("h i", 2) "`n" Caesar("Hi", 20)
