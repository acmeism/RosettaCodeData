GetPhysicalCursorPos()
{
    static POINT, init := VarSetCapacity(POINT, 8, 0) && NumPut(8, POINT, "Int")
    if (DllCall("User32.dll\GetPhysicalCursorPos", "Ptr", &POINT))
    {
        return, { 0 : NumGet(POINT, 0, "Int"), 1 : NumGet(POINT, 4, "Int") }
    }
}
GetPhysicalCursorPos := GetPhysicalCursorPos()

MsgBox, % "GetPhysicalCursorPos function`n"
        . "POINT structure`n`n"
        . "x-coordinate:`t`t"     GetPhysicalCursorPos[0]   "`n"
        . "y-coordinate:`t`t"     GetPhysicalCursorPos[1]
