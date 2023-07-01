;------------------------------------------------------------------------
Gui, 1: +E0x20 +Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist()
OnExit, Exit
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
Width :=1400, Height := 1050
hbm := CreateDIBSection(Width, Height)
hdc := CreateCompatibleDC()
obm := SelectObject(hdc, hbm)
G := Gdip_GraphicsFromHDC(hdc)
Gdip_SetSmoothingMode(G, 4)
;------------------------------------------------------------------------
w := 300, h := 200
xmin := A_ScreenWidth/2-w/2	, xmax := A_ScreenWidth/2+w/2
ymin := A_ScreenHeight/2-h/2 , ymax := A_ScreenHeight/2+h/2
colors := ["C0C0C0","808080","FFFFFF","800000","FF0000","800080","FF00FF","008000"
		,"00FF00","808000","FFFF00","000080","0000FF","008080","00FFFF"]
site := []
loop, 15
{
	Random, x, % xmin, % xmax
	Random, y, % ymin, % ymax
	site[A_Index, "x"] := x
	site[A_Index, "y"] := y
}
y:= ymin
while (y<=ymax)
{
	x:=xmin
	while (x<=xmax)
	{
		distance := []
		for S, coord in site
			distance[dist(x, y, coord.x, coord.y)] := S
		CS := Closest_Site(distance)
		pBrush := Gdip_BrushCreateSolid("0xFF" . colors[CS])
		Gdip_FillEllipse(G, pBrush, x, y, 2, 2)
		x++
	}
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
	y++
}
pBrush 	:= Gdip_BrushCreateSolid(0xFF000000)
for S, coord in site
	Gdip_FillEllipse(G, pBrush, coord.x, coord.y, 4, 4)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
;------------------------------------------------------------------------
Gdip_DeleteBrush(pBrush)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
return
;------------------------------------------------------------------------
Dist(x1,y1,x2,y2){
	return Sqrt((x2-x1)**2 + (y2-y1)**2)
}
;------------------------------------------------------------------------
Closest_Site(distance){
	for d, i in distance
		if A_Index = 1
			min := d, site := i
		else
			min := min < d ? min : d
			, site := min < d ? site : i
	return site
}
;------------------------------------------------------------------------
Exit:
Gdip_Shutdown(pToken)
ExitApp
Return
;------------------------------------------------------------------------
