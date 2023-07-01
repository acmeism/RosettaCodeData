gdip1()
KochX := 0, KochY := 0
Koch(0, 0, A_ScreenWidth, A_ScreenHeight, 4, Arr:=[])
xmin := xmax := ymin := ymax := 0
for i, point in Arr
{
	xmin := A_Index = 1 ? point.x : xmin < point.x ? xmin : point.x
	xmax := point.x > xmax ? point.x : xmax
	ymin := A_Index = 1 ? point.y : ymin < point.y ? ymin : point.y
	ymax := point.y > ymax ? point.y : ymax
}
for i, point in Arr
	points .= point.x - xmin + KochX "," point.y - ymin + KochY "|"
points := Trim(points, "|")
Gdip_DrawLines(G, pPen, Points)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
return
; ---------------------------------------------------------------

Koch(x1, y1, x2, y2, iter, Arr) {
	Pi := 3.141592653589793
	angle := Pi / 3 	; 60 degrees
	x3 := (x1*2 + x2) / 3
	y3 := (y1*2 + y2) / 3
	x4 := (x1 + x2*2) / 3
	y4 := (y1 + y2*2) / 3
	x5 := x3 + (x4-x3)*Cos(angle) + (y4-y3)*Sin(angle)
	y5 := y3 - (x4-x3)*Sin(angle) + (y4-y3)*Cos(angle)
	if (iter > 0)
	{
		iter--
		koch(x1, y1, x3, y3, iter, Arr)
		koch(x3, y3, x5, y5, iter, Arr)
		koch(x5, y5, x4, y4, iter, Arr)
		koch(x4, y4, x2, y2, iter, Arr)
	}
	else
	{
		Arr[Arr.count()+1, "x"] := x1, Arr[Arr.count(), "y"] := y1
		Arr[Arr.count()+1, "x"] := x3, Arr[Arr.count(), "y"] := y3
		Arr[Arr.count()+1, "x"] := x5, Arr[Arr.count(), "y"] := y5
		Arr[Arr.count()+1, "x"] := x4, Arr[Arr.count(), "y"] := y4
		Arr[Arr.count()+1, "x"] := x2, Arr[Arr.count(), "y"] := y2
	}
}
; ---------------------------------------------------------------
gdip1(){
	global
	If !pToken := Gdip_Startup()
	{
		MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
		ExitApp
	}
	OnExit, Exit
	Width := A_ScreenWidth, Height := A_ScreenHeight
	Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
	Gui, 1: Show, NA
	hwnd1 := WinExist()
	hbm := CreateDIBSection(Width, Height)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetSmoothingMode(G, 4)
	pPen := Gdip_CreatePen(0xFFFF0000, 2)
}
; ---------------------------------------------------------------
gdip2(){
	global
	Gdip_DeleteBrush(pBrush)
	Gdip_DeletePen(pPen)
	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(G)
}
; ---------------------------------------------------------------
Exit:
gdip2()
Gdip_Shutdown(pToken)
ExitApp
Return
