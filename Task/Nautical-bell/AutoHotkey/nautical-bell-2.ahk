res := ""
loop, 24
{
	hr := SubStr("0" A_Index -1, -1)
	Loop 60
	{
		min := SubStr("0" A_Index -1, -1)
		if (min = 0 || min = 30)
			res .= hr ":" min "`t" NauticalBell(hr, min).bells "`t" NauticalBell(hr, min).pattern "`n"
	}
}
MsgBox, 262144, , % "Time`tBells`tPattern`n" res
return
