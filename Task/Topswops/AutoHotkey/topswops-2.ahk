Cards := [2, 4, 1, 3]
Res := Print(Cards)
while (Cards[1]<>1)
{
	Cards := Topswops(Cards, Cards[1])
	Res .= "`n"Print(Cards)
}
MsgBox % Res

Print(M){
	for i, val in M
			Res .= (A_Index=1?"":"`t") val
	return Trim(Res,"`n")
}
