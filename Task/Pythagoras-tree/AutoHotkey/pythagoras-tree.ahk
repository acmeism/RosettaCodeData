pToken := Gdip_Startup()
gdip1()
Pythagoras_tree(600, 600, 712, 600, 1)
UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
OnExit, Exit
return

Pythagoras_tree(x1, y1, x2, y2, depth){
    global G, hwnd1, hdc, Width, Height
    if (depth > 7)
        Return

    Pen := Gdip_CreatePen(0xFF808080, 1)
    Brush1 := Gdip_BrushCreateSolid(0xFFFFE600)
    Brush2 := Gdip_BrushCreateSolid(0xFFFAFF00)
    Brush3 := Gdip_BrushCreateSolid(0xFFDBFF00)
    Brush4 := Gdip_BrushCreateSolid(0xFFDBFF00)
    Brush5 := Gdip_BrushCreateSolid(0xFF9EFF00)
    Brush6 := Gdip_BrushCreateSolid(0xFF80FF00)
    Brush7 := Gdip_BrushCreateSolid(0xFF60FF00)

    dx := x2 - x1 , dy := y1 - y2
    x3 := x2 - dy , y3 := y2 - dx
    x4 := x1 - dy , y4 := y1 - dx
    x5 := x4 + (dx - dy) / 2
    y5 := y4 - (dx + dy) / 2

    ; draw box/triangle
    Gdip_FillPolygon(G, Brush%depth%, x1 "," y1 "|" x2 "," y2 "|" x3 "," y3 "|" x4 "," y4 "|" x1 "," y1)
    Gdip_FillPolygon(G, Brush%depth%, x4 "," y4 "|" x5 "," y5 "|" x3 "," y3 "|" x4 "," y4)
	
    ; draw outline
    Gdip_DrawLines(G, Pen, x1 "," y1 "|" x2 "," y2 "|" x3 "," y3 "|" x4 "," y4 "|" x1 "," y1)
    Gdip_DrawLines(G, Pen, x4 "," y4 "|" x5 "," y5 "|" x3 "," y3 "|" x4 "," y4)

    Pythagoras_tree(x4, y4, x5, y5, depth+1)
    Pythagoras_tree(x5, y5, x3, y3, depth+1)
}

gdip1(){
    global
    Width := A_ScreenWidth, Height := A_ScreenHeight
    Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
    Gui, 1: Show, NA
    hwnd1 := WinExist()
    OnMessage(0x201, "WM_LBUTTONDOWN")
    hbm := CreateDIBSection(Width, Height)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    G := Gdip_GraphicsFromHDC(hdc)
    Gdip_SetSmoothingMode(G, 4)
}
; ---------------------------------------------------------------
WM_LBUTTONDOWN(){
    PostMessage, 0xA1, 2
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
exit:
gdip2()
ExitApp
return
