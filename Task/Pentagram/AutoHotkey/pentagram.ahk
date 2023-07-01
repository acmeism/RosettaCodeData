#Include Gdip.ahk	; https://autohotkey.com/boards/viewtopic.php?f=6&t=6517
Width :=A_ScreenWidth, Height := A_ScreenHeight
Gui, 1: +E0x20 +Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist()
OnExit, Exit

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start.
	. Please ensure you have gdiplus on your system
	ExitApp
}

hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
pBrush 	:= Gdip_BrushCreateSolid(0xFF6495ED)
pPen 	:= Gdip_CreatePen(0xff000000, 3)

;---------------------------------
LL := 165
Cx := Floor(A_ScreenWidth/2)
Cy := Floor(A_ScreenHeight/2)
phi := 54
;---------------------------------
loop, 5
{
	theta := abs(180-144-phi)
	p1x := Floor(Cx + LL * Cos(phi * 0.01745329252))
	p1y := Floor(Cy + LL * Sin(phi * 0.01745329252))
	p2x := Floor(Cx - LL * Cos(theta * 0.01745329252))
	p2y := Floor(Cy - LL * Sin(theta * 0.01745329252))
	phi+= 72
	Gdip_FillPolygon(G, pBrush, p1x "," p1y "|" Cx "," Cy "|" p2x "," p2y)
}
loop, 5
{
	theta := abs(180-144-phi)
	p1x := Floor(Cx + LL * Cos(phi * 0.01745329252))
	p1y := Floor(Cy + LL * Sin(phi * 0.01745329252))
	p2x := Floor(Cx - LL * Cos(theta * 0.01745329252))
	p2y := Floor(Cy - LL * Sin(theta * 0.01745329252))
	phi+= 72
	Gdip_DrawLines(G, pPen, p1x "," p1y "|" p2x "," p2y ) ; "|" Cx "," Cy )
}
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
Gdip_DeleteBrush(pBrush)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
return
;----------------------------------------------------------------------
Esc::
Exit:
Gdip_Shutdown(pToken)
ExitApp
Return
