n := 2.5
a := 200
b := 200
SuperEllipse(n, a, b)
return

SuperEllipse(n, a, b){
    global
    pToken    := Gdip_Startup()
    π := 3.141592653589793, oCoord := [], oX := [], oY := []
    nn := 2/n
    loop 361
    {
        t := (A_Index-1) * π/180
        ; https://en.wikipedia.org/wiki/Superellipse
        x := abs(cos(t))**nn * a * sgn(cos(t))
        y := abs(sin(t))**nn * b * sgn(sin(t))
        oCoord[A_Index] := [x, y]
        oX[Floor(x)] := true, oY[Floor(y)] := true
    }
    dx := 0 - oX.MinIndex() + 10
    dy := 0 - oY.MinIndex() + 10
    w := oX.MaxIndex()-oX.MinIndex() + 20
    h := oY.MaxIndex()-oY.MinIndex() + 20

    Gdip1(w, h)
    pPen := Gdip_CreatePen("0xFF00FF00", 2)
    for i, obj in oCoord
    {
        x2 := obj.1+dx, y2 := obj.2+dy
        if i>1
            Gdip_DrawLine(G, pPen, x1, y1, x2, y2)
        x1 := x2, y1 := y2
    }
    UpdateLayeredWindow(hwnd, hdc)
}
;----------------------------------------------------------------
sgn(n){
    return (n>0?1:n<0?-1:0)
}
;----------------------------------------------------------------
Gdip1(w:=0, h:=0){
    global
    w := w ? w : A_ScreenWidth
    h := h ? h : A_ScreenHeight
    x := A_ScreenWidth/2 - w/2
    y := A_ScreenHeight/2 - h/2
    Gui, gdip1: -Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop
    Gui, gdip1: Show, w%w% h%h% x%x% y%y%
    hwnd    := WinExist()
    hbm        := CreateDIBSection(w, h)
    hdc        := CreateCompatibleDC()
    obm        := SelectObject(hdc, hbm)
    G        := Gdip_GraphicsFromHDC(hdc)
    Gdip_SetSmoothingMode(G, 4)
    pBrush    := Gdip_BrushCreateSolid("0xFF000000")
    Gdip_FillRoundedRectangle(G, pBrush, 0, 0, w, h, 5)
    Gdip_DeleteBrush(pBrush)
    UpdateLayeredWindow(hwnd, hdc)
    OnMessage(0x201, "WM_LBUTTONDOWN")
}
;----------------------------------------------------------------
Gdip2(){
    global
    SelectObject(hdc, obm)
    DeleteObject(hbm)
    DeleteDC(hdc)
    Gdip_DeleteGraphics(G)
    Gdip_Shutdown(pToken)
}
;----------------------------------------------------------------
WM_LBUTTONDOWN(){
    PostMessage, 0xA1, 2
}
;----------------------------------------------------------------
Exit:
gdip2()
ExitApp
Return
;----------------------------------------------------------------
