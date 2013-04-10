N=o more
Z=99
L:=Z M:=(B:=" bottle")"s"
Loop 99
V.=L (W:=(O:=" of beer")" on the wall")",`n"L O ",`nTake one down and pass it around,`n"(L:=(--Z ? Z:"N"N)(Z=1 ? B:M))W ".`n`n"
Gui,Add,Edit,w600 h250,% V L W ", n"N M O ".`nGo to the store and buy some more, 99"M W "."
Gui,Show
Return
GuiClose:
ExitApp
