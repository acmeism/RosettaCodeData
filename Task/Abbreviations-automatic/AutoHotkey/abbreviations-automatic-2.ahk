data := "
(
Sunday Monday Tuesday Wednesday Thursday Friday Saturday

Sondag Maandag Dinsdag Woensdag Donderdag Vrydag Saterdag
E_djelë E_hënë E_martë E_mërkurë E_enjte E_premte E_shtunë
Ehud Segno Maksegno Erob Hamus Arbe Kedame
Al_Ahad Al_Ithinin Al_Tholatha'a Al_Arbia'a Al_Kamis Al_Gomia'a Al_Sabit
)"

for i, line in StrSplit(data, "`n", "`r")
{
    line := RegExReplace(line, "\s+", " ")
    len := AutoAbbreviations(line)
    abbrev := ""
    for j, day in StrSplit(line, " ")
        abbrev .= SubStr(day, 1, len) " "
    result .= len " > " abbrev "`n"
}
MsgBox % result
return
