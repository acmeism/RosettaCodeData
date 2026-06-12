SierpinskiW	:= 500
SierpinskiH	:= 500
level 		:= 5
cx		:= SierpinskiW/2
cy		:= SierpinskiH
h		:= cx / (2**(level+1))
Arr := []
squareCurve(level)
xmin := xmax := ymin := ymax := 0
for i, point in Arr
{
	xmin := A_Index = 1 ? point.x : xmin < point.x ? xmin : point.x
	xmax := point.x > xmax ? point.x : xmax
	ymin := A_Index = 1 ? point.y : ymin < point.y ? ymin : point.y
	ymax := point.y > ymax ? point.y : ymax
}
SierpinskiX := A_ScreenWidth/2 - (xmax-xmin)/2	, SierpinskiY := A_ScreenHeight/2 - (ymax-ymin)/2
for i, point in Arr
	points .= point.x - xmin + SierpinskiX "," point.y - ymin + SierpinskiY "|"
points := Trim(points, "|")
gdip1()
Gdip_DrawLines(G, pPen, Points)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
return

; ---------------------------------------------------------------
lineTo(newX, newY) {
	global
	Arr[Arr.count()+1, "x"] := newX-SierpinskiW/2+h
	Arr[Arr.count()  , "y"] := SierpinskiH-newY+2*h
	cx := newX
	cy := newY
}
; ---------------------------------------------------------------
sierN(level) {
	global
	if (level = 1) {
		lineTo(cx+h, cy-h)	; lineNE()
		lineTo(cx, cy-2*h)	; lineN()
		lineTo(cx-h, cy-h)	; lineNW()
	}
	else{
		sierN(level - 1)
		lineTo(cx+h, cy-h)	; lineNE()
		sierE(level - 1)
		lineTo(cx, cy-2*h)	; lineN()
		sierW(level - 1)
		lineTo(cx-h, cy-h)	; lineNW()
		sierN(level - 1)
	}
}
; ---------------------------------------------------------------
sierE(level) {
	global
	if (level = 1) {
		lineTo(cx+h, cy+h)	; lineSE()
		lineTo(cx+2*h, cy)	; lineE()
		lineTo(cx+h, cy-h)	; lineNE()
	}
	else {
		sierE(level - 1)
		lineTo(cx+h, cy+h)	; lineSE()
		sierS(level - 1)
		lineTo(cx+2*h, cy)	; lineE()
		sierN(level - 1)
		lineTo(cx+h, cy-h)	; lineNE()
		sierE(level - 1)
	}
}
; ---------------------------------------------------------------
sierS(level) {
	global
	if (level = 1) {
		lineTo(cx-h, cy+h)	; lineSW()
		lineTo(cx, cy+2*h)	; lineS()
		lineTo(cx+h, cy+h)	; lineSE()
	}
	else {
		sierS(level - 1)
		lineTo(cx-h, cy+h)	; lineSW()
		sierW(level - 1)
		lineTo(cx, cy+2*h)	; lineS()
		sierE(level - 1)
		lineTo(cx+h, cy+h)	; lineSE()
		sierS(level - 1)
	}
}
; ---------------------------------------------------------------
sierW(level) {
	global
	if (level = 1) {
		lineTo(cx-h, cy-h)	; lineNW()
		lineTo(cx-2*h, cy)	; lineW()
		lineTo(cx-h, cy+h)	; lineSW()
	}
	else {
		sierW(level - 1)
		lineTo(cx-h, cy-h)	; lineNW()
		sierN(level - 1)
		lineTo(cx-2*h, cy)	; lineW()
		sierS(level - 1)
		lineTo(cx-h, cy+h)	; lineSW()
		sierW(level - 1)
	}
}
; ---------------------------------------------------------------
squareCurve(level) {
	global
	sierN(level)
	lineTo(cx+h, cy-h)	; lineNE()
	sierE(level)
	lineTo(cx+h, cy+h)	; lineSE()
	sierS(level)
	lineTo(cx-h, cy+h)	; lineSW()
	sierW(level)
	lineTo(cx-h, cy-h)	; lineNW()
	lineTo(cx+h, cy-h)	; lineNE()
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
