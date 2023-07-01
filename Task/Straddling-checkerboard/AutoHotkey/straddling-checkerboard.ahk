board := "
(
ET AON RIS
BCDFGHJKLM
PQ/UVWXYZ.
)"
Text = One night-it was on the twentieth of March, 1888-I was returning
StringUpper, Text, Text
Text := RegExReplace(text, "[^A-Z0-9]")
Num2 := InStr(board, A_Space)               -1
Num3 := InStr(board, A_Space, true, Num1+1) -1
Loop Parse, Text
{
	char := A_LoopField
	Loop Parse, board, `n
	{
		If (Pos := InStr(A_LoopField, char))
			out .= Num%A_Index% . Pos-1
		else if (Pos := InStr(A_LoopField, "/")) && InStr("0123456789", char)
			out .= Num%A_Index% . Pos-1 . char
	}
}
MsgBox % out

i := 0
While (LoopField := SubStr(out, ++i, 1)) <> ""
{
	If (LoopField = num2) or (LoopField = num3)
		col := SubStr(out, ++i, 1)
	else	col := 0
	Loop Parse, board, `n
	{
		If !col && A_Index = 1
			dec .= SubStr(A_LoopField, LoopField+1, 1)
		Else If (Num%A_Index% = LoopField) && col
			dec .= SubStr(A_LoopField, col+1, 1)
		If SubStr(dec, 0) = "/"
			dec := SubStr(dec, 1, StrLen(dec)-1) . SubStr(out, ++i, 1)
	}
}
MsgBox % dec
