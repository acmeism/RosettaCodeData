' version 21-06-2015
' compile with: fbc -s console or fbc -s gui
' Xiaolin Wu’s line-drawing algorithm
'shared var and macro's

Dim Shared As UInteger wu_color

#Macro ipart(x)
Int(x)             ' integer part
#EndMacro

#Macro round(x)
Int((x) + .5)      ' round off
#EndMacro

#Macro fpart(x)
Frac(x)            ' fractional part
#EndMacro

#Macro rfpart(x)
' 1 - Frac(x)    ' seems to give problems for very small x
IIf(1 - Frac(x) >= 1, 1, 1 - Frac(x))
#EndMacro

#Macro plot(x, y , c)
' use the alpha channel to set the amount of color
PSet(x,y), wu_color Or (Int(c * 255)) Shl 24
#EndMacro

Sub drawline(x0 As Single, y0 As Single, x1 As Single, y1 As Single,_
    col As UInteger = RGB(255,255,255))

    wu_color = col And &HFFFFFF ' strip off the alpha channel information

    Dim As Single gradient
    Dim As Single xend, yend, xgap, intery
    Dim As UInteger xpxl1, ypxl1, xpxl2, ypxl2, x
    Dim As Integer steep = Abs(y1 - y0) > Abs(x1 - x0) ' boolean

    If steep Then
        Swap x0, y0
        Swap x1, y1
    End If

    If x0 > x1 Then
        Swap x0, x1
        Swap y0, y1
    End If

    gradient = (y1 - y0) / (x1 - x0)

    ' first endpoint
    ' xend = round(x0)
    xend = ipart(x0)
    yend = y0 + gradient * (xend - x0)
    xgap = rfpart(x0 + .5)
    xpxl1 = xend              ' this will be used in the main loop
    ypxl1 = ipart(yend)
    If steep Then
        plot(ypxl1,   xpxl1, rfpart(yend) * xgap)
        plot(ypxl1+1, xpxl1,  fpart(yend) * xgap)
    Else
        plot(xpxl1, ypxl1,   rfpart(yend) * xgap)
        plot(xpxl1, ypxl1+1,  fpart(yend) * xgap)
    End If
    intery = yend + gradient  ' first y-intersecction for the main loop

    ' handle second endpoint
    ' xend = round(x1)
    xend = ipart(x1)
    yend = y1 + gradient * (xend - x1)
    xgap = fpart(x1 + .5)
    xpxl2 = xend              ' this will be used in the main loop
    ypxl2 = ipart(yend)
    If steep Then
        plot(ypxl2,   xpxl2, rfpart(yend) * xgap)
        plot(ypxl2+1, xpxl2,  fpart(yend) * xgap)
    Else
        plot(xpxl2, ypxl2,   rfpart(yend) * xgap)
        plot(xpxl2, ypxl2+1,  fpart(yend) * xgap)
    End If

    ' main loop
    If steep Then
        For x = xpxl1 + 1 To xpxl2 - 1
            plot(ipart(intery),   x, rfpart(intery))
            plot(ipart(intery)+1, x,  fpart(intery))
            intery = intery + gradient
        Next
    Else
        For x = xpxl1 + 1 To xpxl2 - 1
            plot(x, ipart(intery),   rfpart(intery))
            plot(x, ipart(intery)+1,  fpart(intery))
            intery = intery + gradient
        Next
    End If

End Sub

' ------=< MAIN >=------

#Define W_  600
#Define H_  600

#Include Once "fbgfx.bi"   ' needed setting the screen attributes
Dim As Integer i
Dim As String fname = __FILE__

ScreenRes W_, H_, 32,, FB.GFX_ALPHA_PRIMITIVES

Randomize Timer

For i = 0 To H_ Step H_\30
    drawline(0, 0, W_, i, Int(Rnd * &HFFFFFF))
Next

For i = 0 To W_ Step W_\30
    drawline(0, 0, i, H_, Int(Rnd * &HFFFFFF))
Next

i = InStr(fname,".bas")
fname = Left(fname, Len(fname)-i+1)
WindowTitle fname + "    hit any key to end program"

While Inkey <> "" : Wend
Sleep
End
