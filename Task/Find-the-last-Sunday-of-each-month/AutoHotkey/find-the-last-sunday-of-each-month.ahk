InputBox, Year, , Enter a year., , 300, 135
Date := Year . "0101"

while SubStr(Date, 1, 4) = Year {
    FormatTime, WD, % Date, WDay
    if (WD = 1)
        MM := LTrim(SubStr(Date, 5, 2), "0"), Day%MM% := SubStr(Date, 7, 2)
    Date += 1, Days
}

Gui, Font, S10, Courier New
Gui, Add, Text, , % "Last Sundays of " Year ":`n---------------------"

Loop, 12 {
    FormatTime, Month, % Year (A_Index > 9 ? "" : "0") A_Index, MMMM
    Gui, Add, Text, y+1, % Month (StrLen(Month) > 7 ? "" : "`t") "`t" Day%A_Index%
}

Gui, Show
return
