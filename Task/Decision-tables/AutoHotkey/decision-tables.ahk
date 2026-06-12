Conditions =
(
Printer does not print			|Y|Y|Y|Y|N|N|N|N|
A red light is flashing			|Y|Y|N|N|Y|Y|N|N|
Printer is unrecognized			|Y|N|Y|N|Y|N|Y|N|
)

Actions=
(
Check the power cable			| | |x| | | | | |
Check the printer-computer cable	|x| |x| | | | | |
Ensure printer software is installed	|x| |x| |x| |x| |
Check/replace ink			|x|x| | |x|x| | |
Check for paper jam			| |x| |x| | | | |
)

Condition:=[], Action:=[], Correlation:=[]
loop, parse, Conditions, `n
{
    No:= A_Index, 	RegExMatch(A_LoopField, "^(.*?)\t+(.*)", m),	Cond%No% := m1
    for k, v in StrSplit(m2, "|")
	Condition[No, k] := v="Y"?1:0
}
loop, parse, Actions, `n
{
    No:= A_Index	, RegExMatch(A_LoopField, "^(.*?)\t+(.*)", m),	Act%No% := m1
    for k, v in StrSplit(m2, "|")
	Action[No, A_Index] := v="X"?1:0
}

loop, % Condition[1].MaxIndex()
{
    j := A_Index,	    CondLine:=ActLine:=""
    loop, % Condition.MaxIndex()
	CondLine .= Condition[A_Index,j]
    loop, % Action.MaxIndex()
	ActLine.= Action[A_Index,j]?1:0
    Correlation[CondLine]:=ActLine
}

Gui, font,, Courier
Gui, add, text, w456
Gui, add, text, wp h1 0x7 y+0
loop, parse, Conditions, `n
{
    Gui, add, text, y+0 , % A_LoopField
    Gui, add, text, wp h1 0x7 y+0
}
Gui, add, text, wp
Gui, add, text, wp h1 0x7 y+0
loop, parse, Actions, `n
{
    Gui, add, text, y+0 , % A_LoopField
    Gui, add, text, wp h1 0x7 y+0
}
Gui, add, text, wp
loop, % Condition.MaxIndex()
    Gui, add, Checkbox,vC%A_Index% gSubmit wp h15, % Cond%A_Index%
Gui, add, text, wp , take the following actions(s):
AM := Action.MaxIndex()
Gui, add, Edit, vOutput ReadOnly r%AM% wp -TabStop
Gui, show
return

Submit:
Gui, Submit, NoHide
CondLine:=Res:=""
loop, % Condition.MaxIndex()
    CondLine.= C%A_Index%
MyCorr := Correlation[CondLine]
loop, parse, MyCorr
    if A_LoopField
	Res .= Act%A_Index% "`n"
GuiControl,, Output, % Res
return
