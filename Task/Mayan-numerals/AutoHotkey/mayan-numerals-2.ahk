for i, n in [4005, 8017, 326205, 886205, 194481]
{
	x := MayanNumerals(n)
	Gui, Font, S12, Consolas
	Gui, Add, Text, , % n
	Gui, Add, Text, y+0, % x
	Gui, Show, y100
	MsgBox, 262180, , continue with next number?
	IfMsgBox, No
		ExitApp
	Gui, Destroy
}
