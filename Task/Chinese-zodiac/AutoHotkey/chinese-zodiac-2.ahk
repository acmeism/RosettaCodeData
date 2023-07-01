loop 12
{
	n := 1983+A_Index
	output .= Chinese_zodiac(n) "`n"
}
MsgBox % output "`n" Chinese_zodiac(2017)
return
