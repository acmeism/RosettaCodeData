; Generate 10 strings with equal left and right brackets
Loop, 5
{
	B = %A_Index%
	loop 2
	{
		String =
		Loop % B
			String .= "[`n"
		Loop % B
			String .= "]`n"
		Sort, String, Random
		StringReplace, String, String,`n,,All
		Example .= String " - " IsBalanced(String) "`n"
	}
}
	MsgBox % Example
return

IsBalanced(Str)
{
	Loop, PARSE, Str
	{
		If A_LoopField = [
			i++
		Else if A_LoopField = ]
			i--
		If i < 0
			return "NOT OK"
	}
	Return "OK"
}
