Loop, 5
	Out .= Chess960() "`n"
MsgBox, % RTrim(Out, "`n")

Chess960() {
	P := {}
	P[K := Rand(2, 7)] := Chr(0x2654)	; King
	P[Rand(1, K - 1)] := Chr(0x2656)	; Rook 1
	P[Rand(K + 1, 8)] := Chr(0x2656)	; Rook 2
	Loop, 8
		Remaining .= P[A_Index] ? "" : A_Index "`n"
	Sort, Remaining, Random N
	P[Bishop1 := SubStr(Remaining, 1, 1)] := Chr(0x2657)	; Bishop 1
	Remaining := SubStr(Remaining, 3)
	Loop, Parse, Remaining, `n
		if (Mod(Bishop1 - A_LoopField, 2))
			Odd .= A_LoopField "`n"
		else
			Even .= A_LoopField "`n"
	X := StrSplit(Odd Even, "`n")
	P[X.1] := Chr(0x2657)	; Bishop 2
	P[X.2] := Chr(0x2655)	; Queen
	P[X.3] := Chr(0x2658)	; Knight 1
	P[X.4] := Chr(0x2658)	; Knight 2
	for Key, Val in P
		Out .= Val
	return Out
}

Rand(Min, Max) {
	Random, n, Min, Max
	return n
}
