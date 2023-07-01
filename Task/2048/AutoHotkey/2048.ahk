Grid := [], s := 16, w := h := S * 4.5
Gui, font, s%s%
Gui, add, text, y1
loop, 4
{
	row := A_Index
	loop, 4
	{
		col := A_Index
		if col = 1
			Gui, add, button, v%row%_%col% xs  y+1 w%w% h%h% -TabStop, % Grid[row,col] := 0
		else
			Gui, add, button, v%row%_%col% x+1 yp  w%w% h%h%  -TabStop, % Grid[row,col] := 0
	}
}
Gui, show,, 2048
;------------------------------

Start:
for row, obj in Grid
	for col, val in obj
		Grid[row,col] := 0
	
Grid[1,1]:=2
ShowGrid()
return

;------------------------------
GuiClose:
ExitApp
return
;------------------------------
#IfWinActive, 2048
;------------------------------
up::
move := false
loop, 4
{
	col := A_Index
	Loop, 3
	{
		row := A_Index
		if Grid[row, col] && (Grid[row, col] = Grid[row+1, col])
			Grid[row, col] *=2	, Grid[row+1, col] := 0, move := true
	}
}

loop, 4
{
	row := A_Index
	loop, 4
	{
		col := A_Index
		loop, 4
			if !Grid[row, col]
				loop, 3
					if !Grid[row, col] && Grid[row+A_Index, col]
					{
						Grid[row, col] := Grid[row+A_Index, col]	, Grid[row+A_Index, col] := 0, move := true
						if (Grid[row, col] = Grid[row-1, col])
							Grid[row-1, col] *=2	, Grid[row, col] := 0, move := true
					}
	}
}
gosub, AddNew
return
;------------------------------
Down::
move := false
loop, 4
{
	col := A_Index
	Loop, 3
	{
		row := 5-A_Index
		if Grid[row, col] && (Grid[row, col] = Grid[row-1, col])
			Grid[row, col] *=2	, Grid[row-1, col] := 0, move := true
	}
}

loop, 4
{
	row := 5-A_Index
	loop, 4
	{
		col := A_Index
		loop, 4
			if !Grid[row, col]
				loop, 3
					if !Grid[row, col] && Grid[row-A_Index, col]
					{
						Grid[row, col] := Grid[row-A_Index, col]	, Grid[row-A_Index, col] := 0, move := true
						if (Grid[row, col] = Grid[row+1, col])
							Grid[row+1, col] *=2	, Grid[row, col] := 0, move := true
					}
	}
}
gosub, AddNew
return
;------------------------------
Left::
move := false
loop, 4
{
	row := A_Index
	Loop, 3
	{
		col := A_Index
		if Grid[row, col] && (Grid[row, col] = Grid[row, col+1])
			Grid[row, col] *=2	, Grid[row, col+1] := 0, move := true
	}
}

loop, 4
{
	col := A_Index
	loop, 4
	{
		row := A_Index
		loop, 4
			if !Grid[row, col]
				loop, 3
					if !Grid[row, col] && Grid[row, col+A_Index]
					{
						Grid[row, col] := Grid[row, col+A_Index]	, Grid[row, col+A_Index] := 0, move := true
						if (Grid[row, col] = Grid[row, col-1])
							Grid[row, col-1] *=2	, Grid[row, col] := 0, move := true
					}

	}
}
gosub, AddNew
return
;------------------------------
Right::
move := false
loop, 4
{
	row := A_Index
	Loop, 3
	{
		col := 5-A_Index
		if Grid[row, col] && (Grid[row, col] = Grid[row, col-1])
			Grid[row, col] *=2	, Grid[row, col-1] := 0, move := true
	}
}

loop, 4
{
	col := 5-A_Index
	loop, 4
	{
		row := A_Index
		loop, 4
			if !Grid[row, col]
				loop, 3
					if !Grid[row, col] && Grid[row, col-A_Index]
					{
						Grid[row, col] := Grid[row, col-A_Index]	, Grid[row, col-A_Index] := 0, move := true
						if (Grid[row, col] = Grid[row, col+1])
							Grid[row, col+1] *=2	, Grid[row, col] := 0, move := true
					}
	}
}
gosub, AddNew
return

;------------------------------
#IfWinActive
;------------------------------
AddNew:
if EndOfGame()
{
	MsgBox Done `nPress OK to retry
	goto start
}
return

;------------------------------
EndOfGame(){
	global
	if Move
		AddRandom()
	ShowGrid()
	for row, obj in Grid
		for col, val in obj
			if !grid[row,col]
				return 0
			
	for row, obj in Grid
		for col, val in obj
			if (grid[row,col] = grid[row+1,col]) || (grid[row,col] = grid[row-1,col]) || (grid[row,col] = grid[row,col+1]) || (grid[row,col] = grid[row,col-1])
				return 0
	return 1
}

;------------------------------
ShowGrid(){
	global Grid
	for row, obj in Grid
		for col, val in obj
		{
			GuiControl,, %row%_%col%, %val%
			if val
				GuiControl, Show, %row%_%col%
			else
				GuiControl, Hide, %row%_%col%
		}
}

;------------------------------
AddRandom(){
	global Grid
	ShowGrid()
	Sleep, 200
	for row, obj in Grid
		for col, val in obj
			if !grid[row,col]
				list .= (list?"`n":"") row "," col
	Sort, list, random
	Rnd := StrSplit(list, "`n").1
	Grid[StrSplit(rnd, ",").1, StrSplit(rnd, ",").2] := 2
}
;------------------------------
