cube := [], counter:=0
while counter<30 {
	cube[(n := A_Index)**3] := true
	if !cube[n**2]
		counter++, res .= n**2 " "
	else
		res .= "[" n**2 "] "
}
MsgBox % Trim(res, " ")
