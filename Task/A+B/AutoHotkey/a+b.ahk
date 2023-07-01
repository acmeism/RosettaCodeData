Gui, Add, Edit, vEdit ;Enter your A+B, i.e. 5+3 or 5+3+1+4+6+2
Gui, Add, Button, gAdd, Add
Gui, Add, Edit, ReadOnly x+10 w80
Gui, Show
return

Add:
Gui, Submit, NoHide
Loop, Parse, Edit, + ;its taking each substring separated by "+" and its storing it in A_LoopField
	var += A_LoopField ;here its adding it to var
GuiControl, Text, Edit2, %var% ;here it displays var in the second edit control
var := 0 ;here it makes sure var is 0 so it won't contain the value from the previous addition
return
