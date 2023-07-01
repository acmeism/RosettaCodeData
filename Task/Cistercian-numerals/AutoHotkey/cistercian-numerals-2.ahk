Gui, font, S24, Consolas
Gui, add, Text, vE1 w150 r12
Gui, show, x0 y0
for i, num in [0, 1, 20, 300, 4000, 5555, 6789, 2022]
{
    GuiControl,, E1, % CistercianNumerals(num)
    MsgBox % num
}
return
