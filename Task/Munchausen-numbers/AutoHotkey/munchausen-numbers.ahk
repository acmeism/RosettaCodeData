Loop, 5000
{
	Loop, Parse, A_Index
		var += A_LoopField**A_LoopField
	if (var = A_Index)
		num .= var "`n"
	var := 0
}
Msgbox, %num%
