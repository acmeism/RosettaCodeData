gdip1()
PeanoX := A_ScreenWidth/2 - 100, PeanoY := A_ScreenHeight/2 - 100
Peano(PeanoX, PeanoY, 3**3, 5, 5, Arr:=[])
xmin := xmax := ymin := ymax := 0
for i, point in Arr
{
	xmin := A_Index = 1 ? point.x : xmin < point.x ? xmin : point.x
	xmax := point.x > xmax ? point.x : xmax
	ymin := A_Index = 1 ? point.y : ymin < point.y ? ymin : point.y
	ymax := point.y > ymax ? point.y : ymax
}
for i, point in Arr
	points .= point.x - xmin + PeanoX "," point.y - ymin + PeanoY "|"
points := Trim(points, "|")
Gdip_DrawLines(G, pPen, Points)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
return
; ---------------------------------------------------------------
Peano(x, y, lg, i1, i2, Arr) {
	if (lg =1 )
	{
		Arr[Arr.count()+1, "x"] := x
		Arr[Arr.count(), "y"] := y
		return
	}
	lg := lg/3
	Peano(x+(2*i1*lg)	, y+(2*i1*lg)		, lg	, i1	, i2	, Arr)
	Peano(x+((i1-i2+1)*lg)	, y+((i1+i2)*lg)	, lg	, i1	, 1-i2	, Arr)
	Peano(x+lg		, y+lg			, lg	, i1	, 1-i2	, Arr)
	Peano(x+((i1+i2)*lg)	, y+((i1-i2+1)*lg)	, lg	, 1-i1	, 1-i2	, Arr)
	Peano(x+(2*i2*lg)	, y+(2*(1-i2)*lg)	, lg	, i1	, i2	, Arr)
	Peano(x+((1+i2-i1)*lg)	, y+((2-i1-i2)*lg)	, lg	, i1	, i2	, Arr)
	Peano(x+(2*(1-i1)*lg)	, y+(2*(1-i1)*lg)	, lg	, i1	, i2	, Arr)
	Peano(x+((2-i1-i2)*lg)	, y+((1+i2-i1)*lg)	, lg	, 1-i1	, i2	, Arr)
	Peano(x+(2*(1-i2)*lg)	, y+(2*i2*lg)		, lg	, 1-i1	, i2	, Arr)
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
