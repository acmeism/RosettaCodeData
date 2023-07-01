Size := 20
Grid := [], Deltas := ["-1,0","1,0","0,-1","0,1"], Width := Size * 2.5
Gui, font, S%Size%
Gui, add, text, y1
loop, 4
{
	Row := A_Index
	loop, 4
	{
		Col := A_Index
		Gui, add, button, % (Col=1 ? "xs y+1" : "x+1 yp") " v" Row "_" Col " w" Width " gButton -TabStop", % Grid[Row,Col] := Col + (Row-1)*4 ; 1-16
	}
}
GuiControl, Hide, % Row "_" Col	; 4_4
Gui, add, Button, % "xs gShuffle w" 4 * Width + 3, Shuffle
Gui, show,, 15 Puzzle
return
;------------------------------
GuiClose:
ExitApp
return
;------------------------------
Shuffle:
Shuffle := true
loop, 1000
{
	Random, Rnd, 1,4
	Move(StrSplit(Deltas[Rnd], ",").1, StrSplit(Deltas[Rnd], ",").2)
}
Shuffle := false
return
;------------------------------
Button:
buttonRow := SubStr(A_GuiControl, 1, 1), ButtonCol := SubStr(A_GuiControl, 3, 1)
if Abs(buttonRow-Row) > 1 || Abs(ButtonCol-Col) > 1 || Abs(buttonRow-Row) = Abs(ButtonCol-Col)
	return
Move(buttonRow-Row, ButtonCol-Col)
return
;------------------------------
#IfWinActive, 15 Puzzle
;------------------------------
Down::
Move(-1, 0)
return
;------------------------------
Up::
Move(1, 0)
return
;------------------------------
Right::
Move(0, -1)
return
;------------------------------
Left::
Move(0, 1)
return
;------------------------------
#IfWinActive
;------------------------------
Move(deltaRow, deltaCol){
	global
	if (Row+deltaRow=0) || (Row+deltaRow=5) || (Col+deltaCol=0) || (Col+deltaCol=5)
		return
	GuiControl, Hide, % Row+deltaRow "_" Col+deltaCol
	GuiControl, Show, % Row "_" Col
	GuiControl,, %Row%_%Col%, % Grid[Row+deltaRow, Col+deltaCol]
	Grid[Row, Col] := Grid[Row+deltaRow, Col+deltaCol]
	Grid[Row+=deltaRow, Col+=deltaCol] := 16
	if Shuffle
		return
	gridCont := ""
	for m, obj in grid
		for n, val in obj
			gridCont .= val ","
	if (Trim(gridCont, ",") = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16")
		MsgBox, 262208, 15 Puzzle, You solved 15 Puzzle
}
