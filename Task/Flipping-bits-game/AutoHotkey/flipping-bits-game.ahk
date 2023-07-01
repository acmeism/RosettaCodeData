size := 3 ; max 26
Gui, Add, Button, , O
Loop, %size%
{
	x := chr(A_Index+64)
	If x = A
		Loop, %size%
			Gui, Add, Button, y+4 gFlip, % A_Index
	Gui, Add, Button, ym gFlip, % x
	Loop, %size%
	{
		y := A_Index
		Random, %x%%y%, 0, 1
		Gui, Add, Edit, v%x%%y% ReadOnly, % %x%%y%
	}
}
Gui, Add, Text, ym, Moves:`nTarget:
Loop, %size%
{
	x := chr(A_Index+64)
	Loop, %size%
	{
		y := A_Index
		Gui, Add, Edit, % y=1 ? x="A" ? "xp+0 ym+30" : "x+14 ym+30" : "" . "ReadOnly vt" x y, % t%x%%y% := %x%%y%
	}
}Gui, Add, Text, xp-18 ym w30 Right vMoves, % Moves:=1

; randomize
While (i < size)
{
	Random, z, 1, %size%
	Random, x, 0, 1
	z := x ? chr(z+64) : z
	Solution .= z ; to cheat
	If Flip(z, size)
		i := 0 ; ensure we are not at the solution
	Else
		i++ ; count
}
Gui, Show, NA
Return

Flip(z, size) {
	Loop, %size%
	{
		If z is alpha
			GuiControl, , %z%%A_Index%, % %z%%A_Index% := !%z%%A_Index%
		Else
		{
			AIndex := chr(A_Index+64)
			GuiControl, , %AIndex%%z%, % %AIndex%%z% := !%AIndex%%z%
		}
	}
	Loop, %size%
	{
		x := chr(A_Index+64)
		Loop, %size%
		{
			y := A_Index
			If (%x%%y% != t%x%%y%)
				Return 0
		}
	}
	Return 1
}

Flip:
	GuiControl, , Moves, % Moves++
	If Flip(A_GuiControl, size)
	{
		Msgbox Success in %Moves% moves!
		Reload
	}
Return

ButtonO:
	Reload
Return

GuiEscape:
GuiClose:
	ExitApp
Return
