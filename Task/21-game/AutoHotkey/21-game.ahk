Gui, font, S16
Gui, add, Radio, vRadioC , Cake
Gui, add, Radio, vRadioE x+0 Checked, Easy
Gui, add, Radio, vRadioH x+0, Hard
Gui, add, text, xs vT, Total : 00
Gui, add, text, xs vComputer, Computer Dealt 00
Gui, add, text, xs Section, Player 1
loop, 3
	Gui, add, button, x+5 vPlayer1_%A_Index% gTotal, % A_Index
Gui, add, button, xs vReset gReset, reset
Gui show,, 21 Game
Winners := [1,5,9,13,17,21]
gosub, reset
return
;-----------------------------------
reset:
total := 0
GuiControl,, T, % "Total : " SubStr("00" Total, -1)
GuiControl,, Computer, % "Computer Waiting"
Loop 3
	GuiControl, Enable, % "Player1_" A_Index
Random, rnd, 0, 1
if rnd
{
	Loop 3
		GuiControl, Disable, % "Player1_" A_Index
	gosub ComputerTurn
}
return
;-----------------------------------
Total:
Added := SubStr(A_GuiControl, 9,1)
Total += Added
GuiControl,, T, % "Total : " SubStr("00" Total, -1)
if (total >= 21)
{
	MsgBox % "Player 1 Wins"
	gosub reset
	return
}
Loop 3
	GuiControl, Disable, % "Player1_" A_Index
gosub, ComputerTurn
return
;-----------------------------------
ComputerTurn:
Gui, Submit, NoHide
Sleep 500
if RadioE
{
	if (total < 13)
		RadioC := true
	else
		RadioH := true		
}
if RadioC
{
	Random, Deal, 1, 3
	total += Deal
}
if RadioH
{
	for i, v in Winners
		if (total >= v)
			continue
		else
		{
			Deal := v - total
			if Deal > 3
				Random, Deal, 1, 3
			total += Deal
			break
		}
}
GuiControl,, T, % "Total : " SubStr("00" Total, -1)
GuiControl,, Computer, % "Computer Dealt " Deal
if (total=21)
{
	MsgBox Computer Wins
	gosub, reset
}
else
	Loop 3
		GuiControl, Enable, % "Player1_" A_Index
return
