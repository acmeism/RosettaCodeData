; ---------------------------------------------------------------
cubeSize	:= 200
deltaX		:= A_ScreenWidth/2
deltaY		:= A_ScreenHeight/2
keyStep		:= 1
mouseStep	:= 0.2
zoomStep	:= 1.1
playSpeed	:= 1
playTimer	:= 10
penSize		:= 5

/*
HotKeys:
!p::			Play/Stop
!x::			change play to x-axis
!y::			change play to y-axis
!z::			change play to z-axis
!NumpadAdd::	Zoom in
!WheelUp::		Zoom in
!NumpadSub::	Zoom out
!WheelDown::	Zoom out
!LButton::		Rotate X-axis, follow mouse
!Up::			Rotate X-axis, CCW
!Down::			Rotate X-axis, CW
!LButton::		Rotate Y-axis, follow mouse
!Right::		Rotate Y-axis, CCW
!Left::			Rotate Y-axis, CW
!RButton::		Rotate Z-axis, follow mouse
!PGUP::			Rotate Z-axis, CW
!PGDN::			Rotate Z-axis, CCW
+LButton::		Move, follow mouse
^esc::			Exitapp
*/
visualCube =
(
			1+--------+5
			 |\         \
			 | 2+--------+6
			 |  |        |
			3+  |   7+   |
			  \ |        |
			   4+--------+8
)

SetBatchLines, -1
coord := cubeSize/2
nodes	:=[[-coord, -coord, -coord]
		,  [-coord, -coord,  coord]
		,  [-coord,  coord, -coord]
		,  [-coord,  coord,  coord]
		,  [ coord, -coord, -coord]
		,  [ coord, -coord,  coord]
		,  [ coord,  coord, -coord]
		,  [ coord,  coord,  coord]]
		
edges	:= [[1, 2], [2, 4], [4, 3], [3, 1]
		,   [5, 6], [6, 8], [8, 7], [7, 5]
		,   [1, 5], [2, 6], [3, 7], [4, 8]]

faces 	:= [[1,2,4,3], [2,4,8,6], [1,2,6,5], [1,3,7,5], [5,7,8,6], [3,4,8,7]]

CP := [(nodes[8,1]+nodes[1,1])/2 , (nodes[8,2]+nodes[1,2])/2]

rotateX3D(-30)
rotateY3D(30)
Gdip1()
draw()
return

; --------------------------------------------------------------
draw() {
	global
	D := ""
	for i, n in nodes
		D .= Sqrt((n.1-CP.1)**2 + (n.2-CP.2)**2) "`t:" i ":`t" n.3 "`n"
	Sort, D, N
	p1 := StrSplit(StrSplit(D, "`n", "`r").1, ":").2
	p2 := StrSplit(StrSplit(D, "`n", "`r").2, ":").2
	hiddenNode := nodes[p1,3] < nodes[p2,3] ? p1 : p2
	
	; Draw Faces
	loop % faces.count() {
		n1 := faces[A_Index, 1]
		n2 := faces[A_Index, 2]
		n3 := faces[A_Index, 3]
		n4 := faces[A_Index, 4]
		if (n1 = hiddenNode) || (n2 = hiddenNode) || (n3 = hiddenNode) || (n4 = hiddenNode)
			continue
		points := nodes[n1,1]+deltaX "," nodes[n1,2]+deltaY
			. "|" nodes[n2,1]+deltaX "," nodes[n2,2]+deltaY
			. "|" nodes[n3,1]+deltaX "," nodes[n3,2]+deltaY
			. "|" nodes[n4,1]+deltaX "," nodes[n4,2]+deltaY
		Gdip_FillPolygon(G, FaceBrush%A_Index%, Points)
	}
	
	; Draw Node-Numbers
	;~ loop % nodes.count() {
		;~ Gdip_FillEllipse(G, pBrush, nodes[A_Index, 1]+deltaX, nodes[A_Index, 2]+deltaY, 4, 4)
		;~ Options := "x" nodes[A_Index, 1]+deltaX " y" nodes[A_Index, 2]+deltaY "c" TextColor " Bold s" size
		;~ Gdip_TextToGraphics(G, A_Index, Options, Font)
	;~ }
	
	; Draw Edges
	loop % edges.count() {
		n1 := edges[A_Index, 1]
		n2 := edges[A_Index, 2]
		if (n1 = hiddenNode) || (n2 = hiddenNode)
			continue
		Gdip_DrawLine(G, pPen, nodes[n1,1]+deltaX, nodes[n1,2]+deltaY, nodes[n2,1]+deltaX, nodes[n2,2]+deltaY)
	}
	UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
}

; ---------------------------------------------------------------
rotateZ3D(theta) { ; Rotate shape around the z-axis
	global
	theta *= 3.141592653589793/180
	sinTheta := sin(theta)
	cosTheta := cos(theta)
	loop % nodes.count() {
		x := nodes[A_Index,1]
		y := nodes[A_Index,2]
		nodes[A_Index,1] := x*cosTheta - y*sinTheta
		nodes[A_Index,2] := y*cosTheta + x*sinTheta
	}
	Redraw()
}

; ---------------------------------------------------------------
rotateX3D(theta) { ; Rotate shape around the x-axis
	global
	theta *= 3.141592653589793/180
	sinTheta := sin(theta)
	cosTheta := cos(theta)
	loop % nodes.count() {
		y := nodes[A_Index, 2]
		z := nodes[A_Index, 3]
		nodes[A_Index, 2] := y*cosTheta - z*sinTheta
		nodes[A_Index, 3] := z*cosTheta + y*sinTheta
	}
	Redraw()
}

; ---------------------------------------------------------------
rotateY3D(theta) { ; Rotate shape around the y-axis
	global
	theta *= 3.141592653589793/180
	sinTheta := sin(theta)
	cosTheta := cos(theta)
	loop % nodes.count() {
		x := nodes[A_Index, 1]
		z := nodes[A_Index, 3]
		nodes[A_Index, 1] := x*cosTheta + z*sinTheta
		nodes[A_Index, 3] := z*cosTheta - x*sinTheta
	}
	Redraw()
}

; ---------------------------------------------------------------
Redraw(){
	global
	gdip2()
	gdip1()
	draw()
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
	TextColor:="FFFFFF00", size := 18
	Font := "Arial"
	Gdip_FontFamilyCreate(Font)
	pBrush := Gdip_BrushCreateSolid(0xFFFF00FF)
	FaceBrush1 := Gdip_BrushCreateSolid(0xFF0000FF)	; blue
	FaceBrush2 := Gdip_BrushCreateSolid(0xFFFF0000) ; red
	FaceBrush3 := Gdip_BrushCreateSolid(0xFFFFFF00) ; yellow
	FaceBrush4 := Gdip_BrushCreateSolid(0xFFFF7518) ; orange
	FaceBrush5 := Gdip_BrushCreateSolid(0xFF00FF00) ; lime
	FaceBrush6 := Gdip_BrushCreateSolid(0xFFFFFFFF) ; white
	pPen := Gdip_CreatePen(0xFF000000, penSize)
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
; Viewing Hotkeys ----------------------------------------------
; HotKey Play/Stop ---------------------------------------------
!p::
SetTimer, rotateTimer, % (toggle:=!toggle)?playTimer:"off"
return

rotateTimer:
axis := !axis ? "Y" : axis
rotate%axis%3D(playSpeed)
return

!x::
!y::
!z::
axis := SubStr(A_ThisHotkey, 2, 1)
return

; HotKey Zoom in/out -------------------------------------------
!NumpadAdd::
!NumpadSub::
!WheelUp::
!WheelDown::
loop % nodes.count()
{
	nodes[A_Index, 1] := nodes[A_Index, 1] * (InStr(A_ThisHotkey, "Add") || InStr(A_ThisHotkey, "Up") ? zoomStep : 1/zoomStep)
	nodes[A_Index, 2] := nodes[A_Index, 2] * (InStr(A_ThisHotkey, "Add") || InStr(A_ThisHotkey, "Up") ? zoomStep : 1/zoomStep)
	nodes[A_Index, 3] := nodes[A_Index, 3] * (InStr(A_ThisHotkey, "Add") || InStr(A_ThisHotkey, "Up") ? zoomStep : 1/zoomStep)
}
Redraw()
return

; HotKey Rotate around Y-Axis ----------------------------------
!Right::
!Left::
rotateY3D(keyStep * (InStr(A_ThisHotkey,"right") ? 1 : -1))
return

; HotKey Rotate around X-Axis ----------------------------------
!Up::
!Down::
rotateX3D(keyStep * (InStr(A_ThisHotkey, "Up") ? 1 : -1))
return

; HotKey Rotate around Z-Axis ----------------------------------
!PGUP::
!PGDN::
rotateZ3D(keyStep * (InStr(A_ThisHotkey, "UP") ? 1 : -1))
return

; HotKey, Rotate around X/Y-Axis -------------------------------
!LButton::
MouseGetPos, pmouseX, pmouseY
while GetKeyState("Lbutton", "P")
{
	MouseGetPos, mouseX, mouseY
	DeltaMX := mouseX - pmouseX
	DeltaMY := pmouseY - mouseY
	if (DeltaMX || DeltaMY)
	{
		MouseGetPos, pmouseX, pmouseY
		rotateY3D(DeltaMX)
		rotateX3D(DeltaMY)
	}
}
return

; HotKey Rotate around Z-Axis ----------------------------------
!RButton::
MouseGetPos, pmouseX, pmouseY
while GetKeyState("Rbutton", "P")
{
	MouseGetPos, mouseX, mouseY
	DeltaMX := mouseX - pmouseX
	DeltaMY := mouseY - pmouseY
	DeltaMX *= mouseY < deltaY ? mouseStep : -mouseStep
	DeltaMY *= mouseX > deltaX ? mouseStep : -mouseStep
	if (DeltaMX || DeltaMY)
	{
		MouseGetPos, pmouseX, pmouseY
		rotateZ3D(DeltaMX)
		rotateZ3D(DeltaMY)
	}
}
return

; HotKey, Move -------------------------------------------------
+LButton::
MouseGetPos, pmouseX, pmouseY
while GetKeyState("Lbutton", "P")
{
	MouseGetPos, mouseX, mouseY
	deltaX += mouseX - pmouseX
	deltaY += mouseY - pmouseY
	pmouseX := mouseX
	pmouseY := mouseY
	Redraw()
}
return

; ---------------------------------------------------------------
^esc::
Exit:
gdip2()
Gdip_Shutdown(pToken)
ExitApp
Return
; ---------------------------------------------------------------
