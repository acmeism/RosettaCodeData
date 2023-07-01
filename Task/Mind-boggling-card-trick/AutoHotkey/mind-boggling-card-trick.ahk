;==========================================================
; create cards
cards := [], suits := ["♠","♥","♦","♣"], num := 0
for i, v in StrSplit("A,2,3,4,5,6,7,8,9,10,J,Q,K",",")
	for i, suit in suits
		cards[++num] := v suit
;==========================================================
; create gui
w := 40
Gui, font, S10
Gui, font, S10 CRed
Gui, add, text, w100 , Face Up Red
loop, 26
	Gui, add, button, % "x+0 w" w " vFR" A_Index
Gui, add, text, xs w100 , Face Down
loop, 26
	Gui, add, button, % "x+0 w" w " vHR" A_Index
Gui, font, S10 CBlack
Gui, add, text, xs w100 , Face Up Black
loop, 26
	Gui, add, button, % "x+0 w" w " vFB" A_Index
Gui, add, text, xs w100 , Face Down
loop, 26
	Gui, add, button, % "x+0 w" w " vHB" A_Index
Gui, add, button, xs gShuffle , Shuffle
Gui, add, button, x+1 Disabled vDeal gDeal , Deal
Gui, add, button, x+1 Disabled vMove gMove, Move
Gui, add, button, x+1 Disabled vShowAll gShowAll , Show All
Gui, add, button, x+1 Disabled vPeak gPeak, Peak
Gui, add, StatusBar
Gui, show
SB_SetParts(200,200)
SB_SetText("0 Face Down Red Cards", 1)
SB_SetText("0 Face Down Black Cards", 2)
return
;==========================================================
Shuffle:
list := "", shuffled := []
Loop, 52
	list .= A_Index ","
list := Trim(list, ",")
Sort, list, Random D,
loop, parse, list, `,
	shuffled[A_Index] := cards[A_LoopField]
loop, 26{
	GuiControl,, % "FR" A_Index
	GuiControl,, % "FB" A_Index
	GuiControl,, % "HR" A_Index
	GuiControl,, % "HB" A_Index
}
GuiControl, Enable, Deal
GuiControl, Disable, Move
GuiControl, Disable, ShowAll
GuiControl, Enable, Peak
return
;==========================================================
peak:
list := ""
for i, v in shuffled
	list .= i ": " v (mod(i,2)?"`t":"`n")
ToolTip , % list, 1000, 0
return
;==========================================================
Deal:
Color := "",
GuiControl, Disable, Deal
FaceRed:= [], FaceBlack := [], HiddenRed := [], HiddenBlack := [], toggle := 0
for i, card in shuffled
	if toggle:=!toggle	{
		if InStr(card, "♥") || InStr(card, "♦") {
			Color := "Red"
			faceRed.push(card)
			GuiControl,, % "FR" faceRed.Count(), % card
		}
		else if InStr(card, "♠") || InStr(card, "♣") {
			Color := "Black"
			faceBlack.push(card)
			GuiControl,, % "FB" faceBlack.Count(), % card
		}
	}
	else{
		Hidden%Color%.push(card)
		GuiControl,, % (color="red"?"HR":"HB") Hidden%Color%.Count(), % "?"
		Sleep, 50
	}
GuiControl, Enable, Move
GuiControl, Enable, ShowAll
return
;==========================================================
Move:
tempR := [], tempB := []
Random, rndcount, 1, % HiddenRed.Count() < HiddenBlack.Count() ? HiddenRed.Count() : HiddenBlack.Count()
loop, % rndcount{
	Random, rnd, 1, % HiddenRed.Count()
	Random, rnd, 1, % HiddenBlack.Count()
	tempR.push(HiddenRed.RemoveAt(rnd))
	tempB.push(HiddenBlack.RemoveAt(rnd))
}
list := ""
for i, v in tempR
	list .= v "`t" tempB[i] "`n"
MsgBox % "swapping " rndcount " cards between face down Red and face down Black`n" (ShowAll?"Red`tBlack`n" list:"")
for i, v in tempR
	HiddenBlack.Push(v)
for i, v in tempB
	HiddenRed.push(v)
if ShowAll
	gosub, ShowAll
return
;==========================================================
ShowAll:
ShowAll := true, countR := countB := 0
loop, 26{
	GuiControl,, % "HR" A_Index
	GuiControl,, % "HB" A_Index
}
for i, card in HiddenRed
	GuiControl,, % "HR" i, % (card~= "[♥♦]"?"[":"") card (card~= "[♥♦]"?"]":"")
	, countR := (card~= "[♥♦]") ? countR+1 : countR
for i, card in HiddenBlack
	GuiControl,, % "HB" i, % (card~= "[♠♣]"?"[":"") card  (card~= "[♠♣]"?"]":"")
	, countB := (card~= "[♠♣]") ? countB+1 : countB
SB_SetText(countR " Face Down Red Cards", 1)
SB_SetText(countB " Face Down Black Cards", 2)
return
;==========================================================
