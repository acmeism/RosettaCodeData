gosub Init
Gui, +AlwaysOnTop
Gui, font, s12, consolas
Gui, add, Edit, vEditGrid x10 y10 ReadOnly, % grid2Text(oGrid)
Gui, add, Text, vScore x10 y+10 w200 ReadOnly, % "Your Score = " Score
Gui, show,, Snake
GuiControl, Focus, Score
return
;-----------------------------------------
Init:
Width := 100, Height := 30			; set grid size
tail := 20, step := 10
Timer := 75
item := 0, direction := ""
oTrail := [], Score := 0
xx := generateGrid(width, Height)
oGrid := xx.1
row := xx.2, col := xx.3
return
;-----------------------------------------
Move:
if !item
{
	loop
	{
		Random, itemC, 3, % width-2
		Random, itemR, 3, % Height-2
	}
	until, !oGrid[itemR, itemC]
	oGrid[itemR, itemC] := "@"
	item := true
}
gosub, crawl
return
;-----------------------------------------
#IfWinActive, Snake
left::
Right::
up::
Down::
if ((A_ThisHotkey = "right") 	&& (Direction = "left"))
|| ((A_ThisHotkey = "left") 	&& (Direction = "right"))
|| ((A_ThisHotkey = "up") 		&& (Direction = "Down"))
|| ((A_ThisHotkey = "Down") 	&& (Direction = "up"))
|| ((A_ThisHotkey = "right") 	&& (Direction = "right"))
|| ((A_ThisHotkey = "left") 	&& (Direction = "left"))
|| ((A_ThisHotkey = "up") 		&& (Direction = "up"))
|| ((A_ThisHotkey = "Down") 	&& (Direction = "Down"))
	return

Direction := A_ThisHotkey
gosub, crawl
return
#IfWinActive
;-----------------------------------------
crawl:
switch, Direction	
{
	case "left"	:	oGrid[row  , col--] := 1
	case "Right"	:	oGrid[row  , col++] := 1
	case "up" 	:	oGrid[row--, col  ] := 1
	case "Down"	:	oGrid[row++, col  ] := 1
}

; out of bounds or snake eats itself
if oGrid[row, col] = 1 || col < 1 || col > width || row < 1 || row > height
	gosub, YouLose

; snake eats item
if (oGrid[row, col] = "@")
{
	item := false
	tail += step
	GuiControl,, Score, % "Your Score = " ++Score
}

; snake advances
oGrid[row, col] := 2
oTrail.Push(row "," col)
if (oTrail.count() >= tail)
	x := StrSplit(oTrail.RemoveAt(1), ","),		oGrid[x.1, x.2] := false

GuiControl,, EditGrid, % grid2Text(oGrid)
SetTimer, Move, % 0-Timer
return
;-----------------------------------------
YouLose:
SetTimer, Move, Off
MsgBox, 262180, ,% "Your Score is " Score "`nPlay Again?"
IfMsgBox, No
	ExitApp

gosub Init
GuiControl,, EditGrid, % grid2Text(oGrid)
return
;-----------------------------------------
grid2Text(oGrid){
	for row, obj in oGrid	{
		for col, val in obj		; @=item, 2=Head, 1=tail
			text .=  val = "@" ? "@" : val =2 ? "█" : val = 1 ? "▓" : " "
		text .= "`n"
	}
	return trim(text, "`n")
}
;-----------------------------------------
generateGrid(width, Height){
	global oTrail
	oGrid := []
	loop, % width
	{
		col := A_Index
		loop, % Height
			row := A_Index, oGrid[row, col] := false
	}
	Random, col, 3, % width-2
	Random, row, 3, % Height-2
	oGrid[row, col] := 2
	oTrail.Push(row "," col)
	return [oGrid, row, col]
}
;-----------------------------------------
