Width := 10, Height	:= 10												; set grid size
SleepTime := 0

gosub, Startup

Gui, +AlwaysOnTop
Gui, font, s12, consolas
Gui, add, edit, vEditGrid x10, % maze
Gui, add, button, xs gStartup Default, Generate maze
Gui, add, button, x+10 gSolve, Solve
Gui, show,, maze
GuiControl,, EditGrid, % maze											; show maze
return

;-----------------------------------------------------------------------
^Esc::
GuiEscape:
GuiClose:
ExitApp
return

;-----------------------------------------------------------------------
Startup:
oMaze := []																; initialize
Solved := false
loop, % Height
{
	row := A_Index
	loop, % Width														; create oMaze[row,column] borders
		col := A_Index, oMaze[row,col] :=  "LRTB"						; i.e. oMaze[2,5] := LRTB (add all borders)
}
Random, row, 1, % Height												; random row
Random, col, 1, % Width													; random col
grid := maze2text(oMaze)												; object to text
GuiControl,, EditGrid, % Grid											; show Grid
row := col := 1															; reset to 1,1
oMaze := Generate_maze(row, col, oMaze)									; generate maze starting from random row/column
oMaze[1,1] .= "X"														; start from 1,1
maze := maze2text(oMaze)												; object to text
GuiControl,, EditGrid, % maze											; show maze
GuiControl,, EditRoute													; clear route
GuiControl, Enable, Solve
return

;-----------------------------------------------------------------------
Solve:
GuiControl, Disable, Generate maze
GuiControl, Disable, Solve
loop % oRoute.MaxIndex()
	oRoute.pop()

oSolution	:= Solve(1, 1, oMaze)										; solve starting from 1,1
oMaze 		:= oSolution.1
oRoute 		:= oSolution.2
Update(oMaze, oRoute)
Solved := true
GuiControl, Enable, Generate maze
return

;-----------------------------------------------------------------------
Update(oMaze, oRoute){
	global SleepTime
	GuiControl,, EditGrid, % maze2text(oMaze)
	Sleep, % SleepTime
}

;-----------------------------------------------------------------------
maze2text(oMaze){
	width := oMaze.1.MaxIndex()
	BLK := "█"
	for row, objRow in oMaze
	{
		for col, val in objRow											; add ceiling
		{
			ceiling := InStr(oMaze[row, col] , "x") && InStr(oMaze[row-1, col] , "x") ? "+ " BLK " " : "+   "
			grid .= (InStr(val, "T") ? "+---" : ceiling) (col = Width ? "+`n" : "")
		}
		for col, val in objRow											; add left wall
		{
			wall := SubStr(val, 0) = "X" ? BLK : " "
			grid .= (InStr(val, "L") ? "| " : "  ") wall " " (col = Width ? "|`n" : "") ; add left wall if needed then outer right border
		}
	}
	Loop % Width
		Grid .= "+---"													; add bottom floor
	Grid .= "+"															; add right bottom corner
	return RegExReplace(grid , BLK "   (?=" BLK ")" ,  BLK BLK BLK BLK)	; fill gaps
}

;-----------------------------------------------------------------------
Generate_maze(row, col, oMaze) {
	neighbors := row+1 "," col "`n" row-1 "," col  "`n" row "," col+1  "`n" row "," col-1
	Sort, neighbors, random												; randomize neighbors list
	Loop, parse, neighbors, `n											; for each neighbor
	{
		rowX := StrSplit(A_LoopField, ",").1							; this neighbor row
		colX := StrSplit(A_LoopField, ",").2							; this neighbor column
		if !instr(oMaze[rowX,colX], "LRTB") || !oMaze[rowX, colX]		; if visited (has a missing border) or out of bounds
			continue													; skip
		
		; remove borders
		if (row > rowX)													; Cell is below this neighbor
			oMaze[row,col] := StrReplace(oMaze[row,col], "T") , oMaze[rowX,colX] := StrReplace(oMaze[rowX,colX], "B")
		else if (row < rowX)											; Cell is above this neighbor
			oMaze[row,col] := StrReplace(oMaze[row,col], "B") , oMaze[rowX,colX] := StrReplace(oMaze[rowX,colX], "T")
		else if (col > colX)											; Cell is right of this neighbor
			oMaze[row,col] := StrReplace(oMaze[row,col], "L") , oMaze[rowX,colX] := StrReplace(oMaze[rowX,colX], "R")
		else if (col < colX)											; Cell is left of this neighbor
			oMaze[row,col] := StrReplace(oMaze[row,col], "R") , oMaze[rowX,colX] := StrReplace(oMaze[rowX,colX], "L")
		
		Generate_maze(rowX, colX, oMaze)								; recurse for this neighbor
	}
	return, oMaze
}

;-----------------------------------------------------------------------
Solve(row, col, oMaze){
	static oRoute := []
	oNeighbor := [], targetrow := oMaze.MaxIndex(), targetCol := oMaze.1.MaxIndex()
	
	;~ Update(oMaze, oRoute)
	oRoute.push(row ":" col)											; push current cell address to oRoute
	oMaze[row, col] .= "X"												; mark it visited "X"
		
	if (row = targetrow) && (Col = targetCol)							; if solved
		return true														; return ture

	; create list of Neighbors
	oNeighbor[row, col] := []
	if !InStr(oMaze[row, col], "R")										; if no Right border
		oNeighbor[row, col].push(row "," col+1)							; add neighbor
	if !InStr(oMaze[row, col], "B")										; if no Bottom border
		oNeighbor[row, col].push(row+1 "," col)							; add neighbor
	if !InStr(oMaze[row, col], "T")										; if no Top border
		oNeighbor[row, col].push(row-1 "," col)							; add neighbor
	if !InStr(oMaze[row, col], "L")										; if no Left border
		oNeighbor[row, col].push(row "," col-1)							; add neighbor
	
	; recurese for each oNeighbor
	for each, neighbor in oNeighbor[row, col]							; for each neighbor
	{
		Update(oMaze, oRoute)
		startrow := StrSplit(neighbor, ",").1							; this neighbor
		startCol := StrSplit(neighbor, ",").2							; becomes starting point		
		
		if !InStr(oMaze[startrow, startCol], "X")						; if it was not visited
			if Solve(startrow, startCol, oMaze)							; recurse for current neighbor
				return [oMaze, oRoute]									; return solution if solved
	}
	oRoute.pop()														; no solution found, back track
	oMaze[row, Col] := StrReplace(oMaze[row, Col], "X")					; no solution found, back track
	;~ Update(oMaze, oRoute)
}

;-----------------------------------------------------------------------
#IfWinActive, maze
Right::
Left::
Up::
Down::
if Solved
	return

if (A_ThisHotkey="Right") && (!InStr(oMaze[row,col], "R"))
	oMaze[row, col] := StrReplace(oMaze[row, col], "X")		, col++
if (A_ThisHotkey="Left") && (!InStr(oMaze[row,col], "L"))
	oMaze[row, col] := StrReplace(oMaze[row, col], "X")		, col--
if (A_ThisHotkey="Up") && (!InStr(oMaze[row,col], "T"))
	oMaze[row, col] := StrReplace(oMaze[row, col], "X")		, row--
if (A_ThisHotkey="Down") && (!InStr(oMaze[row,col], "B"))
	oMaze[row, col] := StrReplace(oMaze[row, col], "X")		, row++

oMaze[row, col] .= "X"
GuiControl,, EditGrid, % maze2text(oMaze)

if (col = Width) && (row = Height)
{
	Solved := true
	oMaze[height, width] := StrReplace(oMaze[height, width], "X")
	SleepTime := 0
	gosub, solve
	return
}
return
#IfWinActive
