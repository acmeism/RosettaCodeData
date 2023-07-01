#NoEnv
#SingleInstance, Force

	SetBatchLines, -1
	CoordMode, Mouse
	CoordMode, Pixel
return

CapsLock::
	KeyWait, CapsLock
	MouseGetPos, X, Y
	PixelGetColor, color, X, Y
	FloodFill(x, y, color, 0x000000, 1, "Esc")
	MsgBox Done!
Return

FloodFill( 0x, 0y, target, replacement, mode=1, key="" )
{
	VarSetCapacity(Rect, 16, 0)
	hDC := DllCall("GetDC", UInt, 0)
	hBrush := DllCall("CreateSolidBrush", UInt, replacement)
	
	l := 0
	while l >= 0
	{
		if getkeystate(key, "P")
			return
		x := %l%x, y := %l%y
		%l%p++
		p := %l%p
		PixelGetColor, color, x, y
		if (color = target)
		{
			NumPut(x, Rect, 0)
			NumPut(y, Rect, 4)
			NumPut(x+1, Rect, 8)
			NumPut(y+1, Rect, 12)
			DllCall("FillRect", UInt, hDC, Str, Rect, UInt, hBrush)
		}
		else if (p = 1)
		{
			%l%x := %l%y := %l%p := "", l--
			continue
		}
		if (p < 5)
			ol := l++
			, %l%x := %ol%x + (p = 1 ? 1 : p = 2 ? -1 : 0)
			, %l%y := %ol%y + (p = 3 ? 1 : p = 4 ? -1 : 0)
		else
			%l%x := %l%y := %l%p := "", l--
	}
	
	DllCall("ReleaseDC", UInt, 0, UInt, hDC)
	DllCall("DeleteObject", UInt, hBrush)
}
