Const ancho = 400
Const alto = 300
Dim As Integer i, x, y
Dim As Ulong kolor

' Set up graphics
Screenres ancho, alto, 32
Windowtitle "Pattern Generator"

' A little extravagant, this draws a design of dots and lines
' Fill background with color Rgb(&h40, &h80, &hc0)
Line (0, 0)-(ancho-1, alto-1), Rgb(64, 128, 192), BF

' Draw random dots Rgb(&h20, &h40, &h80)
For i = 1 To 2000
    Pset (Rnd * (ancho-1), Rnd * (alto-1)), Rgb(32, 64, 128)
Next

' Draw horizontal lines
For x = 0 To ancho-1
    For y = 240 To 244
        Pset (x, y), Rgb(32, 64, 128)
    Next
    For y = 260 To 264
        Pset (x, y), Rgb(32, 64, 128)
    Next
Next

' Draw vertical lines
For y = 0 To alto-1
    For x = 80 To 84
        Pset (x, y), Rgb(32, 64, 128)
    Next
    For x = 95 To 99
        Pset (x, y), Rgb(32, 64, 128)
    Next
Next

' Open PPM file to write
Dim As Integer ff = Freefile
Open "noutput.ppm" For Binary As #ff
If Err > 0 Then Print "Error opening output file": End

' Write PPM header
Put #ff, , "P6" & Chr(10)
Put #ff, , Str(ancho) & " " & Str(alto) & Chr(10)
Put #ff, , "255" & Chr(10)

' Write pixel data
For y = 0 To alto - 1
    For x = 0 To ancho - 1
        kolor = Point(x, y)
        Put #ff, , Cbyte(kolor Shr 16)  ' Blue
        Put #ff, , Cbyte(kolor Shr 8)   ' Green
        Put #ff, , Cbyte(kolor)         ' Red
    Next
Next

Close #ff

' Convert to JPG using ImageMagick  (pipe logic)
Shell "magick.exe noutput.ppm noutput.jpg"

Sleep
