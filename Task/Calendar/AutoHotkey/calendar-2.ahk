Gui, font,s8, COURIER
Gui, add, edit, vYr w40 r1 Limit4 Number, 1969
Gui, add, edit, vEdit2 w580 r38
Gui, Add, Button, Default Hidden gSubmit
Gui, show

Submit:
Gui, Submit, NoHide
GuiControl,, Edit2, % Calendar(Yr)
return

GuiEscape:
GuiClose:
ExitApp
return
