w := h := 32, maxRows := 10, numPegs := 8
ww := floor(w/2-2), hh := floor(h/2-2)
grid := [], dx := w*4.5
gosub, Decode

Gui, Font, S18, Consolas
loop, 4
{
	i := A_Index-1
	Gui, add, button, % "x" (Mod(i, 4)?"+0":"30") " y"
					.	(Mod(i, 4)?"10" : "10") " w" w " h" h " vGoal" A_Index , ?
}

Gui, Add, Text, % "section x30 h1 0x1000 w" w*6
loop, % maxRows
{
	Gui, Font, S18, consolas
	row := maxRows - A_Index + 1
	loop 4
	{
		col := A_Index, 	i:= col-1
		Gui, add, button, % "x" (Mod(i, 4)?"+0":"s") " y" (Mod(i, 4)?"p":"+2")
						. " w" w " h" h " vButton" row "_" col " gButton"
	}
	Gui, Font, S13, wingdings 2
	loop 2
	{
		col := A_Index, 	i:= col-1
		Gui, add, text, % "x" (Mod(i,2)?"+1":"s+" dx) " y" (Mod(i,2)?"p":"p+1")
						. " w" ww " h" hh " vKeyPeg" row "_" col, % Chr(167)
	}
	loop 2
	{
		col := A_Index+2, 	i:= col-1
		Gui, add, text, % "x" (Mod(i,2)?"+1":"s+" dx) " y" (Mod(i,2)?"p":"+1") 	
						. " w" ww " h" hh " vKeyPeg" row "_" col, % Chr(167)
	}
	Gui, Add, Text, % "section xs h1 0x1000 w" w*6 " y+4"
}
Gui, Font, S12, consolas
Gui, add, Button, % "xs y+10 gSubmit w" W*2 , Submit
Gui, add, Button, % "x+0 gResetMM w" W*2, Reset
Gui, add, Checkbox, % "x+4 vNoDup", No`nDuplicates
Gui, Font, S18
for i, v in pegs
	Gui, add, Radio, % "x" (!Mod(i-1, 4)?"10":"+10") " h" h " w" w+20 " vRadio" A_Index, % v
Gui, show
Row := 1
return
;-----------------------------------------------------------------------
GuiClose:
ExitApp
return
;-----------------------------------------------------------------------
Decode:
Gui, Submit, NoHide
pegs:=[], goal := [], usedPeg :=[]
pool := ["😺","🎃","🧨","⚽","😀","☠","👽","❄","🙉","💗"
	,"💥","🖐","🏈","🎱","👁","🗨","🤙","👄","🐶","🐴"
	,"🦢","🐍","🐞","💣","🐪","🐘","🐰","🐸","🌴","🏀"]

loop, % numPegs
{
	Random, rnd, 1, % pool.count()
	pegs[A_Index] := pool.RemoveAt(rnd)
}
i := 1
while (goal.count()<4)
{
	Random, rnd, 1, % pegs.count()
	if (NoDup && usedPeg[pegs[rnd]])
		continue
	goal[i++] := pegs[rnd]
	usedPeg[pegs[rnd]] := true
}
return
;-----------------------------------------------------------------------
Button:
if GameEnd
	return

Gui, Submit, NoHide
RegExMatch(A_GuiControl, "Button(\d+)_(\d+)", m)
if (m1 <> row)
{
	thisPeg := Grid[m1, m2]
	for i, v in pegs
		if (v=thisPeg)
			GuiControl,, Radio%i%, 1
	GuiControl,, % "Button" row "_" m2, % thisPeg
	Grid[row,m2] := thisPeg
}
else
{
	loop, % pegs.count()
		if Radio%A_Index%
			GuiControl,, % A_GuiControl , % grid[m1, m2] := pegs[A_Index]
}
return
;-----------------------------------------------------------------------
Submit:
if (grid[row].count()<4) || GameEnd
	return

Gui, submit, NoHide
Ans := [], FIP := [], inGoal := []
CIP := CNP := 0, KeyPeg := 1

for i, G in Goal
	inGoal[G] := (inGoal[G] ? inGoal[G] : 0) +1		; save inGoal
loop, 4
	Ans[A_Index] := Grid[row, A_Index]			; save Ans
for i, A in Ans
	if (goal[A_Index] = A)
		CIP++, FIP.push(i), inGoal[A]:=inGoal[A] -1	; Correct In Place, inGoal--
for i, v in FIP
	Ans.RemoveAt(v-i+1)					; remove Correct In Place from Answers
for i, A in Ans
	if (inGoal[A] > 0)
		CNP++, inGoal[A] := inGoal[A] -1		; Correct Not in Place
loop % CIP
	GuiControl,, % "KeyPeg" row "_" KeyPeg++, % Chr(82)	; "✔"
loop % CNP
	GuiControl,, % "KeyPeg" row "_" KeyPeg++, % Chr(83)	; "X"

if (CIP=4 || row=maxRows)
{
	loop 4
		GuiControl,, Goal%A_Index%, % Goal[A_Index]
	MsgBox % CIP = 4 ? "You Win" : "You lose"
	GameEnd := true
}
Row++
return
;-----------------------------------------------------------------------
LAlt:: ; peak at solution (for troubleshooting purposes only!)
loop 4
	GuiControl,, Goal%A_Index%, % Goal[A_Index]
While GetKeyState("Lalt", "P")
	continue
loop 4
	GuiControl,, Goal%A_Index%, % "?"
return
;-----------------------------------------------------------------------
ResetMM:
Grid :=[], GameEnd:= false
loop, 4
{
	Random, rnd, 1, % pegs.count()
	goal[A_Index] := pegs[rnd]
	GuiControl,, Goal%A_Index%, ?
}

loop, % maxRows
{
	row := maxRows - A_Index + 1
	loop 4
	{
		col := A_Index
		GuiControl,, % "KeyPeg" row "_" col, % Chr(167)	; "O"
		GuiControl,, % "Button" row "_" col
	}
}
gosub Decode
loop, 8
	GuiControl,, Radio%A_Index%, % pegs[A_Index]
return
;-----------------------------------------------------------------------
