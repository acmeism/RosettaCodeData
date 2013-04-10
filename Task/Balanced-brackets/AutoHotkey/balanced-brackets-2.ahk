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

IsBalanced(Str){
	While (Instr(Str,"[]"))
		StringReplace, Str, Str,[],,All
	Return Str ? "False" : "True"
}
