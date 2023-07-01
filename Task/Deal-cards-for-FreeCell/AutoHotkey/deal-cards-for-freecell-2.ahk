Gui, font, s12, Courier
Gui, add, edit, w320 r17 -VScroll, % "Game# 1`n" FreeCell(1) "`n`nGame#617`n" FreeCell(617)
Gui, show
return

GuiClose:
GuiEscape:
ExitApp
return
