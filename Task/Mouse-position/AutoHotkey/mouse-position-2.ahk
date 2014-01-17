GetCursorPos()
{
    static POINT, init := VarSetCapacity(POINT, 8, 0) && NumPut(8, POINT, "Int")
    if (DllCall("User32.dll\GetCursorPos", "Ptr", &POINT))
    {
        return, { 0 : NumGet(POINT, 0, "Int"), 1 : NumGet(POINT, 4, "Int") }
    }
}
GetCursorPos := GetCursorPos()

MsgBox, % "GetCursorPos function`n"
        . "POINT structure`n`n"
        . "x-coordinate:`t`t"     GetCursorPos[0]   "`n"
        . "y-coordinate:`t`t"     GetCursorPos[1]
