Gui, font, s12
Gui, add, text, w90, Computer:
loop, 3
	Gui, add, button, x+10 h30 w30 vCB%A_Index%
Gui, add, edit, xs w240 R3 vSequence
Gui, add, text, w90, Human:
loop, 3
	Gui, add, button, x+10 h30 w30 vHB%A_Index% gHumButton, H
Gui, add, button, xm gToss, toss
Gui, add, button, x+10 gReset, Reset
Gui, show,, Penney's game
CompSeq := HumSeq := Seq := GameEnd := ""

RandomStart:
Random, WhoStarts, 1, 2
if (WhoStarts=1)
	gosub, CompButton
return
;-----------------------------------------------
CompButton:
if CompSeq
	return
Loop, 3
{
	Random, coin, 1, 2
	GuiControl,, CB%A_Index%, % coin=1?"H":"T"
	CompSeq .= coin=1?"H":"T"
}
return
;-----------------------------------------------
HumButton:
if HumSeq
	return
GuiControlGet, B,, % A_GuiControl
GuiControl,, % A_GuiControl, % B="H"?"T":"H"
return
;-----------------------------------------------
Toss:
if GameEnd
	return
if !HumSeq
{
	loop 3
	{
		GuiControlGet, B,, HB%A_Index%
		HumSeq .= B
	}
	if (CompSeq = HumSeq)
	{
		MsgBox, 262160, Penney's game, Human's Selection Has to be different From Computer's Selection`nTry Again
		HumSeq := ""
		return
	}
}
if !CompSeq
{
	CompSeq := (SubStr(HumSeq,2,1)="H"?"T":"H") . SubStr(HumSeq,1,2)
	loop, Parse, CompSeq
		GuiControl,, CB%A_Index%, % A_LoopField
}

Random, coin, 1, 2
Seq .= coin=1?"H":"T"
GuiControl,, Sequence, % seq
if (SubStr(Seq, -2) = HumSeq)
	MsgBox % GameEnd := "Human Wins"
else if (SubStr(Seq, -2) = CompSeq)
	MsgBox % GameEnd := "Computer Wins"
return
;-----------------------------------------------
Reset:
loop, 3
{
	GuiControl,, CB%A_Index%
	GuiControl,, HB%A_Index%, H
}
GuiControl,, Sequence
CompSeq := HumSeq := Seq := GameEnd := ""
gosub, RandomStart
return
;-----------------------------------------------
