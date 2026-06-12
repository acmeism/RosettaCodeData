loop, 12{
	First := Last := ""
	n:=42**(A_Index-1)
	while (n>v)
		if (n&v := 2**(A_Index-1))
			First := First ? First : A_Index-1 , Last := A_Index-1
	Res .= 42 "^" A_Index-1 " --> First : " First " , Last : " Last "`n"
}
MsgBox % Res
