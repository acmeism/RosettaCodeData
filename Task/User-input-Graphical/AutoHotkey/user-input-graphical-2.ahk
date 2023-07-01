Gui, Add, Text,, String:
Gui, Add, Text,, Int:
Gui, Add, Button, gGo, Go!
Gui, Add, Edit, vString ym
Gui, Add, Edit, VInt
Gui, Show, Center, Input
Return

Go:
Gui, Submit, NoHide
Msgbox, You entered "%String%" and "%Int%"
ExitApp
Return
