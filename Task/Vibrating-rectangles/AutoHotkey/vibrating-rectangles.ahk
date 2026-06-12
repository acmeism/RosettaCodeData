Vibrating_rectangles()
OnExit, Exit
return

Vibrating_rectangles(){
    global
    pToken    := Gdip_Startup()
    colors := ["0xFFFF0000", "0xFF00FF00", "0xFF0000FF", "0xFFFFFF00", "0xFF00FFFF", "0xFFFF00FF", "0xFFC0C0C0"
             , "0xFF808080", "0xFF800000", "0xFF808000", "0xFF008000", "0xFF800080", "0xFF008080", "0xFF000080"]
    Gdip1(320, 320)
    loop
    {
        x := y := 10, w := h := 300
        color := Colors[Mod(A_Index-1, 14) + 1]
        pPen := Gdip_CreatePen(color, 2)
        loop 20
        {
            if GetKeyState("Esc", "P")
                ExitApp
            Gdip_DrawRectangle(G, pPen, x, y, w, h)
            x += 10, y += 10, w -= 20, h -= 20
            UpdateLayeredWindow(hwnd, hdc)
            Sleep 20
        }
        Sleep 200
    }
    UpdateLayeredWindow(hwnd, hdc)
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
