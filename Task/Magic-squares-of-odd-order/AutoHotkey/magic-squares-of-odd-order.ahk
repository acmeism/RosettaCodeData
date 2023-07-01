msgbox % OddMagicSquare(5)
msgbox % OddMagicSquare(7)
return

OddMagicSquare(oddN){
	sq := oddN**2
	obj := {}
	loop % oddN
		obj[A_Index] := {} 	; dis is row
	mid := Round((oddN+1)/2)
	sum := Round(sq*(sq+1)/2/oddN)
	obj[1][mid] := 1
	cR := 1 , cC := mid
	loop % sq-1
	{
		done := 0 , a := A_index+1
		while !done {
			nR := cR-1 , nC := cC+1
			if !nR
				nR := oddN
			if (nC>oddN)
				nC := 1
			if obj[nR][nC] 	;filled
				cR += 1
			else cR := nR , cC := nC
			if !obj[cR][cC]
				obj[cR][cC] := a , done := 1
		}
	}

	str := "Magic Constant for " oddN "x" oddN " is " sum "`n"
	for k,v in obj
	{
		for k2,v2 in v
			str .= " " v2
		str .= "`n"
	}
	return str
}
