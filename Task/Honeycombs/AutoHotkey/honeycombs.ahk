Columns := 5							; cater for a different number of columns
hexPerCol := 4							; cater for a different number of hexagons
size := 40

w := sqrt(3) * size
h := 2 * size
Coord := [], Chosen := [], Seq:= ""
Letters := StrSplit("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
x := A_ScreenWidth/2  - w*(Columns/2) + w/2
y := A_ScreenHeight/2 - h*(hexPerCol/2) + h/2
x1:= x, y1:=y

Gdip()
; Draw High Columns
loop % Ceil(Columns/2)
{
	col := A_Index
	loop % hexPerCol
	{
		Random, rnd, 1, % Letters.count()
		letter := Letters.RemoveAt(rnd)
		Draw_Hexagon(x,y,size,Letter)
		y += sqrt(3) * size
	}
	x:=x1, y:=y1
	x+= col*3*size
}

; Draw Low Columns
x:= x1, y:=y1
x+= size*1.5, y += sqrt(3) * size/2
loop % Floor(Columns/2)
{
	col := A_Index
	loop % hexPerCol
	{
		Random, rnd, 1, % Letters.count()
		letter := Letters.RemoveAt(rnd)
		Draw_Hexagon(x,y,size,Letter)
		y += sqrt(3) * size
	}
	x:=x1, y:=y1
	x+= size*1.5,	y += sqrt(3) * size/2
	x+= col*3*size
}
OnExit, Exit
Return
;---------------------------------------------------------------
~LButton::
CoordMode, Mouse, Screen
MouseGetPos, mx, my, mc, mw
if (mc <> hwnd1)
	return
minD := []
for L, c in coord
{
	x := c.x
	y := c.y
	D := Sqrt((x-mx)**2 + (y-my)**2)
	minD[D] := L
	min := A_Index = 1 ? D : min < D ? min : D
}
thisLetter := minD[min]
gosub SelectHex
return;
;---------------------------------------------------------------
KeyPress:
thisLetter := A_ThisHotkey
gosub, SelectHex
return
;---------------------------------------------------------------
SelectHex:
if Chosen[thisLetter]
	return
Chosen[thisLetter] := true					; record of chosen letters
Seq .= thisLetter						; record of the chosen letters in order chosed
pBrush := Gdip_BrushCreateSolid(0xFFFF00FF)
x := coord[thisLetter, "x"]
y := coord[thisLetter, "y"]
Draw_Hexagon(x,y,size,thisLetter, "FF000000")
Progress, % "m2 b fs16 zh0 y0 w400 x" A_ScreenWidth/2-200, % Seq,,, Courier New
if (Chosen.Count() = Columns * hexPerCol)
	ExitApp
return
;---------------------------------------------------------------
Draw_Hexagon(x,y,size,Letter,TextColor:="FFFF0000"){
	global
	deg2rad := 3.141592653589793/180
	a := x + Size "," y
	b := x+ Size*Cos(60*deg2rad) "," y + Size*Sin(60*deg2rad)
	c := x+ Size*Cos(120*deg2rad) "," y + Size*Sin(120*deg2rad)
	d := x - Size "," y
	e := x+ Size*Cos(240*deg2rad) "," y + Size*Sin(240*deg2rad)
	f := x+ Size*Cos(300*deg2rad) "," y + Size*Sin(300*deg2rad)
	Gdip_FillPolygon(G, pBrush, a "|" b "|" c "|" d "|" e "|" f)
	Gdip_DrawLines(G, pPen, a "|" b "|" c "|" d "|" e "|" f "|" a)
	Font := "Arial", Gdip_FontFamilyCreate(Font)
	Options := "x" x-size/2 " y" y-size/2 "c" TextColor " Bold s" size
	Gdip_TextToGraphics(G, Letter, Options, Font)
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
	Hotkey, % letter, KeyPress
	Coord[letter, "x"] := x
	Coord[letter, "y"] := y
}
;---------------------------------------------------------------
gdip(){
	global
	Gdip_Startup()
	Width := A_ScreenWidth, Height := A_ScreenHeight
	Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
	Gui, 1: Show, NA
	hwnd1 := WinExist()
	hbm := CreateDIBSection(Width, Height)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetSmoothingMode(G, 4)
	pBrush := Gdip_BrushCreateSolid(0xFFFFFF00)
	pPen := Gdip_CreatePen(0xFF000000, 3)
}
;---------------------------------------------------------------
Exit:
Gdip_DeleteBrush(pBrush)
Gdip_DeletePen(pPen)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_Shutdown(pToken)
ExitApp
Return
;---------------------------------------------------------------
