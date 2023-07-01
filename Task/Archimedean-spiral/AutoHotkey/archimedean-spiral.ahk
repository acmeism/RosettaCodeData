if !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
OnExit, Exit
SysGet, MonitorPrimary, MonitorPrimary
SysGet, WA, MonitorWorkArea, %MonitorPrimary%
WAWidth	:= WARight-WALeft
WAHeight := WABottom-WATop
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist()
hbm := CreateDIBSection(WAWidth, WAHeight)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
pPen := Gdip_CreatePen(0xffff0000, 3)
;--------------------------------
a := 1, b := 4, th := 0.1, step := 0.1
loop, 720
{
	th += step
	r := a + b * th
	x1 := r * Cos(th)
	y1 := r * Sin(th)
	x1 += A_ScreenWidth/2
	y1 += A_ScreenHeight/2	
	if (x2 && y2)
		Gdip_DrawLine(G, pPen, x1, y1, x2, y2)
	x2 := x1, 	y2 := y1
	if GetKeyState("Esc", "P")
		break
	; next two lines are optional to watch it draw
	; Sleep 10
	; UpdateLayeredWindow(hwnd1, hdc, WALeft, WATop, WAWidth, WAHeight)
}
UpdateLayeredWindow(hwnd1, hdc, WALeft, WATop, WAWidth, WAHeight)
;--------------------------------
return

Exit:
Gdip_DeletePen(pPen)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_Shutdown(pToken)
ExitApp
Return
