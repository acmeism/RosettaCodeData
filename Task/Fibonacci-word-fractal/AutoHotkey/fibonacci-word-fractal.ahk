#NoEnv
SetBatchLines, -1
p := 0.3	; Segment length (pixels)
F_Word := 30

SysGet, Mon, MonitorWorkArea
W := FibWord(F_Word)
d := 1
x1 := 0
y1 := MonBottom
Width := A_ScreenWidth
Height := A_ScreenHeight

If (!pToken := Gdip_Startup()) {
	MsgBox, 48, Gdiplus Error!, Gdiplus failed to start. Please ensure you have Gdiplus on your system.
	ExitApp
}
OnExit, Shutdown

Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA

hwnd1 := WinExist()
hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
pPen := Gdip_CreatePen(0xffff0000, 1)

Loop, Parse, W
{
	if (d = 0)
		x2 := x1 + p, y2 := y1
	else if (d = 1 || d = -3)
		x2 := x1, y2 := y1 - p
	else if (d = 2 || d = -2)
		x2 := x1 - p, y2 := y1
	else if (d = 3 || d = -1)
		x2 := x1, y2 := y1 + p
	Gdip_DrawLine(G, pPen, x1, y1, x2, y2)
	if (!Mod(A_Index, 1500))
		UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
	if (A_LoopField = 0) {
		if (!Mod(A_Index, 2))
			d += 1
		else
			d -= 1
	}
	x1 := x2, y1 := y2, d := Mod(d, 4)
}

Gdip_DeletePen(pPen)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
return

FibWord(n, FW1=1, FW2=0) {
	Loop, % n - 2
		FW3 := FW2 FW1, FW1 := FW2, FW2 := FW3
	return FW3
}

Esc::
Shutdown:
Gdip_DeletePen(pPen)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_Shutdown(pToken)
ExitApp
