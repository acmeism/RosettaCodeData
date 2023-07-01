If !pToken := Gdip_Startup()
{
    MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
    ExitApp
}

OnExit, Exit
gdip1()

incr := 0
π := 3.141592653589793
loop
{
    incr := Mod(incr + 0.05, 360)
    x1 := Width/2
    y1 := Height/2
    length := 5
    angle := incr
    Gdip_FillRoundedRectangle(G, pBrush, 0, 0, Width, Height, 0)
    loop 150
    {
        x2 := x1 + length * Cos(angle * π/180)
        y2 := y1 + length * Sin(angle * π/180)
        Gdip_DrawLine(G, pPen, x1, y1, x2, y2)
        x1 := x2
        y1 := y2
        length := length + 3
        angle := Mod(angle + incr, 360)
    }
    UpdateLayeredWindow(hwnd1, hdc, -1, -1, Width, Height)
    Sleep 25
}
return
;----------------------------------------------------------------
Esc:: Pause, toggle
^Esc::ExitApp
;----------------------------------------------------------------
gdip1(){
    global
    Width := A_ScreenWidth+1, Height := A_ScreenHeight+1
    Gui, 1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
    Gui, 1: Show, NA
    hwnd1 := WinExist()
    hbm := CreateDIBSection(Width, Height)
    hdc := CreateCompatibleDC()
    obm := SelectObject(hdc, hbm)
    G := Gdip_GraphicsFromHDC(hdc)
    Gdip_SetSmoothingMode(G, 4)
    pBrush := Gdip_BrushCreateSolid("0xFF000000")
    pPen := Gdip_CreatePen("0xFF00FF00", 1)
}
;----------------------------------------------------------------
gdip2(){
    global
    Gdip_DeletePen(pPen)
    Gdip_DeleteBrush(pBrush)
    SelectObject(hdc, obm)
    DeleteObject(hbm)
    DeleteDC(hdc)
    Gdip_DeleteGraphics(G)
}
;----------------------------------------------------------------
Exit:
gdip2()
Gdip_Shutdown(pToken)
ExitApp
Return
;----------------------------------------------------------------
