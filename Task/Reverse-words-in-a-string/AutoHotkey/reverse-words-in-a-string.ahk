Data := "
(Join`r`n
---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------
)"

Loop, Parse, Data, `n, `r
{
	Loop, Parse, A_LoopField, % A_Space
		Line := A_LoopField " " Line
	Output .= Line "`n", Line := ""
}
MsgBox, % RTrim(Output, "`n")
