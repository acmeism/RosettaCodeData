; gdi+ ahk analogue clock example written by derRaphael
; Parts based on examples from Tic's GDI+ Tutorials and of course on his GDIP.ahk

; This code has been licensed under the terms of EUPL 1.0

#SingleInstance, Force
#NoEnv
SetBatchLines, -1

; Uncomment if Gdip.ahk is not in your standard library
;#Include, Gdip.ahk

If !pToken := Gdip_Startup()
{
   MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
   ExitApp
}
OnExit, Exit

SysGet, MonitorPrimary, MonitorPrimary
SysGet, WA, MonitorWorkArea, %MonitorPrimary%
WAWidth := WARight-WALeft
WAHeight := WABottom-WATop

Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA
hwnd1 := WinExist()

ClockDiameter := 180
Width := Height := ClockDiameter + 2         ; make width and height slightly bigger to avoid cut away edges
CenterX := CenterY := floor(ClockDiameter/2) ; Center x

; Prepare our pGraphic so we have a 'canvas' to work upon
   hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC()
   obm := SelectObject(hdc, hbm), G := Gdip_GraphicsFromHDC(hdc)
   Gdip_SetSmoothingMode(G, 4)

; Draw outer circle
   Diameter := ClockDiameter
   pBrush := Gdip_BrushCreateSolid(0x66008000)
   Gdip_FillEllipse(G, pBrush, CenterX-(Diameter//2), CenterY-(Diameter//2),Diameter, Diameter)
   Gdip_DeleteBrush(pBrush)

; Draw inner circle
   Diameter := ceil(ClockDiameter - ClockDiameter*0.08)  ; inner circle is 8 % smaller than clock's diameter
   pBrush := Gdip_BrushCreateSolid(0x80008000)
   Gdip_FillEllipse(G, pBrush, CenterX-(Diameter//2), CenterY-(Diameter//2),Diameter, Diameter)
   Gdip_DeleteBrush(pBrush)

; Draw Second Marks
   R1 := Diameter//2-1                        ; outer position
   R2 := Diameter//2-1-ceil(Diameter//2*0.05) ; inner position
   Items := 60                                ; we have 60 seconds
   pPen := Gdip_CreatePen(0xff00a000, floor((ClockDiameter/100)*1.2)) ; 1.2 % of total diameter is our pen width
   GoSub, DrawClockMarks
   Gdip_DeletePen(pPen)

; Draw Hour Marks
   R1 := Diameter//2-1                       ; outer position
   R2 := Diameter//2-1-ceil(Diameter//2*0.1) ; inner position
   Items := 12                               ; we have 12 hours
   pPen := Gdip_CreatePen(0xc0008000, ceil((ClockDiameter//100)*2.3)) ; 2.3 % of total diameter is our pen width
   GoSub, DrawClockMarks
   Gdip_DeletePen(pPen)

   ; The OnMessage will let us drag the clock
   OnMessage(0x201, "WM_LBUTTONDOWN")
   UpdateLayeredWindow(hwnd1, hdc, WALeft+((WAWidth-Width)//2), WATop+((WAHeight-Height)//2), Width, Height)
   SetTimer, sec, 1000

sec:
; prepare to empty previously drawn stuff
   Gdip_SetSmoothingMode(G, 1)   ; turn off aliasing
   Gdip_SetCompositingMode(G, 1) ; set to overdraw

; delete previous graphic and redraw background
   Diameter := ceil(ClockDiameter - ClockDiameter*0.18)  ; 18 % less than clock's outer diameter

   ; delete whatever has been drawn here
   pBrush := Gdip_BrushCreateSolid(0x00000000) ; fully transparent brush 'eraser'
   Gdip_FillEllipse(G, pBrush, CenterX-(Diameter//2), CenterY-(Diameter//2),Diameter, Diameter)
   Gdip_DeleteBrush(pBrush)

   Gdip_SetCompositingMode(G, 0) ; switch off overdraw
   pBrush := Gdip_BrushCreateSolid(0x66008000)
   Gdip_FillEllipse(G, pBrush, CenterX-(Diameter//2), CenterY-(Diameter//2),Diameter, Diameter)
   Gdip_DeleteBrush(pBrush)
   pBrush := Gdip_BrushCreateSolid(0x80008000)
   Gdip_FillEllipse(G, pBrush, CenterX-(Diameter//2), CenterY-(Diameter//2),Diameter, Diameter)
   Gdip_DeleteBrush(pBrush)

; Draw HoursPointer
   Gdip_SetSmoothingMode(G, 4)   ; turn on antialiasing
   t := A_Hour*360//12 + (A_Min*360//60)//12 +90
   R1 := ClockDiameter//2-ceil((ClockDiameter//2)*0.5) ; outer position
   pPen := Gdip_CreatePen(0xa0008000, floor((ClockDiameter/100)*3.5))
   Gdip_DrawLine(G, pPen, CenterX, CenterY
      , ceil(CenterX - (R1 * Cos(t * Atan(1) * 4 / 180)))
      , ceil(CenterY - (R1 * Sin(t * Atan(1) * 4 / 180))))
   Gdip_DeletePen(pPen)

; Draw MinutesPointer
   t := A_Min*360//60+90
   R1 := ClockDiameter//2-ceil((ClockDiameter//2)*0.25) ; outer position
   pPen := Gdip_CreatePen(0xa0008000, floor((ClockDiameter/100)*2.7))
   Gdip_DrawLine(G, pPen, CenterX, CenterY
      , ceil(CenterX - (R1 * Cos(t * Atan(1) * 4 / 180)))
      , ceil(CenterY - (R1 * Sin(t * Atan(1) * 4 / 180))))
   Gdip_DeletePen(pPen)

; Draw SecondsPointer
   t := A_Sec*360//60+90
   R1 := ClockDiameter//2-ceil((ClockDiameter//2)*0.2) ; outer position
   pPen := Gdip_CreatePen(0xa000FF00, floor((ClockDiameter/100)*1.2))
   Gdip_DrawLine(G, pPen, CenterX, CenterY
      , ceil(CenterX - (R1 * Cos(t * Atan(1) * 4 / 180)))
      , ceil(CenterY - (R1 * Sin(t * Atan(1) * 4 / 180))))
   Gdip_DeletePen(pPen)

   UpdateLayeredWindow(hwnd1, hdc) ;, xPos, yPos, ClockDiameter, ClockDiameter)
return

DrawClockMarks:
   Loop, % Items
      Gdip_DrawLine(G, pPen
         , CenterX - ceil(R1 * Cos(((a_index-1)*360//Items) * Atan(1) * 4 / 180))
         , CenterY - ceil(R1 * Sin(((a_index-1)*360//Items) * Atan(1) * 4 / 180))
         , CenterX - ceil(R2 * Cos(((a_index-1)*360//Items) * Atan(1) * 4 / 180))
         , CenterY - ceil(R2 * Sin(((a_index-1)*360//Items) * Atan(1) * 4 / 180)) )
return

WM_LBUTTONDOWN() {
   PostMessage, 0xA1, 2
   return
}

esc::
Exit:
   SelectObject(hdc, obm)
   DeleteObject(hbm)
   DeleteDC(hdc)
   Gdip_DeleteGraphics(G)
   Gdip_Shutdown(pToken)
   ExitApp
Return
