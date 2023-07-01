W := H := 640
hw := W / 2
margin := 20
radius := hw - 2 * margin
side := radius * Sin(PI := 3.141592653589793 / 5) * 2
order := 5

gdip1()
drawPentagon(hw, 3*margin, side, order, 1)
return

drawPentagon(x, y, side, depth, colorIndex){
    global G, hwnd1, hdc, Width, Height
    Red        := "0xFFFF0000"
    Green    := "0xFF00FF00"
    Blue    := "0xFF0000FF"
    Magenta    := "0xFFFF00FF"
    Cyan    := "0xFF00FFFF"
    Black    := "0xFF000000"
    Palette    := [Red, Green, Blue, Magenta, Cyan]
    PI        := 3.141592653589793
    Deg72    := 72 * PI/180
    angle    := 3 * Deg72
    ScaleFactor    := 1 / ( 2 + Cos(Deg72) * 2)

    points .= x "," y
    if (depth = 1) {
        loop 5 {
            prevx := x
            prevy := y
            x += Cos(angle) * side
            y -= Sin(angle) * side
            points .= "|" x "," y
            pPen := Gdip_CreatePen(Black, 2)
            Gdip_DrawLines(G, pPen, prevx "," prevy "|" x "," y)
            angle += Deg72
        }
        pBrush := Gdip_BrushCreateSolid(Palette[colorIndex])
        Gdip_FillPolygon(G, pBrush, Points)
        UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
    }
    else{
        side *= ScaleFactor
        dist := side * (1 + (Cos(Deg72)*2))
        loop 5{
            x += Cos(angle) * dist
            y -= Sin(angle) * dist
            colorIndex := Mod(colorIndex+1, 5) + 1
            drawPentagon(x, y, side, depth-1, colorIndex)
            angle += Deg72
        }
    }
}
; ---------------------------------------------------------------
gdip1(){
    global
    If !pToken := Gdip_Startup(){
        MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
        ExitApp
    }
    OnExit, Exit
    Width := 640, Height := 640
    Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
    Gui, 1: Show, NA
    hwnd1 := WinExist()
    hbm := CreateDIBSection(Width, Height)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    G := Gdip_GraphicsFromHDC(hdc)
    Gdip_SetSmoothingMode(G, 4)
    blackCanvas := Gdip_BrushCreateSolid(0xFFFFFFFF)
    Gdip_FillRectangle(G, blackCanvas, 0, 0, Width, Height)
    UpdateLayeredWindow(hwnd1, hdc, 0, 0, Width, Height)
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
Esc::
GuiEscape:
Exit:
gdip2()
Gdip_Shutdown(pToken)
ExitApp
Return
