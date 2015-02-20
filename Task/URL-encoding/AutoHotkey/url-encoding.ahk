MsgBox, % UriEncode("http://foo bar/")

; Modified from http://goo.gl/0a0iJq
UriEncode(Uri)
{
	VarSetCapacity(Var, StrPut(Uri, "UTF-8"), 0)
	StrPut(Uri, &Var, "UTF-8")
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	While Code := NumGet(Var, A_Index - 1, "UChar")
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	SetFormat, IntegerFast, %f%
	Return, Res
}
