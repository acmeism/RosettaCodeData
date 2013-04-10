SetBatchLines, -1
CoordMode, Mouse
CoordMode, Pixel
CapsLock::
KeyWait, CapsLock
MouseGetPos, X, Y
PixelGetColor, color, X, Y
FloodFill(x, y, color, 0x000000, 1, "CapsLock")
MsgBox Done!
Return
FloodFill(x, y, target, replacement, mode=1, key="")
{
   If GetKeyState(key, "P")
      Return
   PixelGetColor, color, x, y
   If (color <> target || color = replacement || target = replacement)
      Return
   VarSetCapacity(Rect, 16, 0)
   NumPut(x, Rect, 0)
   NumPut(y, Rect, 4)
   NumPut(x+1, Rect, 8)
   NumPut(y+1, Rect, 12)
   hDC := DllCall("GetDC", UInt, 0)
   hBrush := DllCall("CreateSolidBrush", UInt, replacement)
   DllCall("FillRect", UInt, hDC, Str, Rect, UInt, hBrush)
   DllCall("ReleaseDC", UInt, 0, UInt, hDC)
   DllCall("DeleteObject", UInt, hBrush)
   FloodFill(x+1, y, target, replacement, mode, key)
   FloodFill(x-1, y, target, replacement, mode, key)
   FloodFill(x, y+1, target, replacement, mode, key)
   FloodFill(x, y-1, target, replacement, mode, key)
   If (mode = 2 || mode = 4)
      FloodFill(x, y, target, replacement, mode, key)
   If (Mode = 3 || mode = 4)
   {
      FloodFill(x+1, y+1, target, replacement, key)
      FloodFill(x-1, y+1, target, replacement, key)
      FloodFill(x+1, y-1, target, replacement, key)
      FloodFill(x-1, y-1, target, replacement, key)
   }
}
