VarSetCapacity(Rect, 16)  ; A RECT is a struct consisting of four 32-bit integers (i.e. 4*4=16).
DllCall("GetWindowRect", UInt, WinExist(), UInt, &Rect)  ; WinExist() returns an HWND.
MsgBox % "Left " . NumGet(Rect, 0, true) . " Top " . NumGet(Rect, 4, true)
    . " Right " . NumGet(Rect, 8, true) . " Bottom " . NumGet(Rect, 12, true)
