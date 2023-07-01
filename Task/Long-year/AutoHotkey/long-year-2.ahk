loop, 100{
	y := 1999+A_Index
	res .= Long_year(y) ? Y " ": ""
}
MsgBox % "Long Years 2000-2100 : " res
return
