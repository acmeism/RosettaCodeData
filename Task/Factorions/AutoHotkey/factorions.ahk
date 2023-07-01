fact:=[]
fact[0] := 1
while (A_Index < 12)
	fact[A_Index] := fact[A_Index-1] * A_Index
b := 9
while (b <= 12) {
	res .= "base " b " factorions:  `t"
	while (A_Index < 1500000){
		sum := 0
		j := A_Index
		while (j > 0){
			d := Mod(j, b)
			sum += fact[d]
			j /= b
		}
		if (sum = A_Index)
			res .= A_Index "  "
	}
	b++
	res .= "`n"
}
MsgBox % res
return
