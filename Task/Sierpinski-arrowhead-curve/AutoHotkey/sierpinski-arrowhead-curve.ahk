order	:= 7
theta	:= 0

curve := []
curve.curveW	:= 1000
curve.curveH	:= 1000
curve.iy	:= 1
curve.cx	:= curve.curveW/2
curve.cy	:= curve.curveH
curve.ch	:= curve.cx/2

arrowhead(order, curve, theta, Arr :=[])
xmin := xmax := ymin := ymax := 0
for i, point in Arr
{
	xmin := A_Index = 1 ? point.x : xmin < point.x ? xmin : point.x
	xmax := point.x > xmax ? point.x : xmax
	ymin := A_Index = 1 ? point.y : ymin < point.y ? ymin : point.y
	ymax := point.y > ymax ? point.y : ymax
}
arrowheadX := A_ScreenWidth/2 - (xmax-xmin)/2	, arrowheadY := A_ScreenHeight/2 - (ymax-ymin)/2
for i, point in Arr
	points .= point.x - xmin + arrowheadX "," point.y - ymin + arrowheadY "|"

points := Trim(points, "|")
gdip1()
Gdip_DrawLines(G, pPen, Points)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
return

; ---------------------------------------------------------------
arrowhead(order, curve, theta, Arr) {
	length := curve.cx
	if (order&1 = 0)
		curve(order, length, theta, 60, Arr)
	else
	{
		theta := turn(theta, 60)
		theta := curve(order, length, theta, -60, Arr)
	}
	drawLine(length, theta, Arr)
}
; ---------------------------------------------------------------
drawLine(length, theta, Arr) {
	global curve
	Arr[Arr.count()+1, "x"] := curve.cx-curve.curveW/2+curve.ch
	Arr[Arr.count(), "y"] := (curve.curveH-curve.cy)*curve.iy+2*curve.ch
	pi := 3.141592653589793
	curve.cx := curve.cx + length * Cos(theta*pi/180)
	curve.cy := curve.cy + length * Sin(theta*pi/180)
}
; ---------------------------------------------------------------
turn(theta, angle) {
	return theta := Mod(theta+angle, 360)
}
; ---------------------------------------------------------------
curve(order, length, theta, angle, Arr) {
	if (order = 0)
		drawLine(length, theta, Arr)
	else
	{
		theta := curve(order-1, length/2, theta, -angle, Arr)
		theta := turn(theta, angle)
		theta := curve(order-1, length/2, theta, angle, Arr)
		theta := turn(theta, angle)
		theta := curve(order-1, length/2, theta, -angle, Arr)
	}
	return theta
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
