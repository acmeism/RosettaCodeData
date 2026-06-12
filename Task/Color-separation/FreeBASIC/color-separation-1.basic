Windowtitle "Color separation, RGB model"
Dim As String imagen = "lena50.bmp"
Dim As Long ancho, alto, f = Freefile()
' open BMP file
Open imagen For Binary Access Read As #f
' retrieve BMP dimensions
Get #f, 19, ancho : Get #f, 23, alto
Close #f
' create image with BMP dimensions
Dim As Any Ptr img = Imagecreate(ancho, alto)
Screenres 40+(ancho*4), alto+10, 32
' load BMP file into image buffer
Bload imagen

Dim As Integer y, x
Dim As Ulong col, r, g, b

'' Create one pixel image for cada color.
Dim imgR As Any Ptr = Imagecreate(ancho, alto)
Dim imgG As Any Ptr = Imagecreate(ancho, alto)
Dim imgB As Any Ptr = Imagecreate(ancho, alto)
For y = 0 To alto-1
    For x = 0 To ancho-1
        col = Point(x,y)
        r = col Shr 16 And 255
        g = col Shr 8  And 255
        b = col        And 255
        Pset imgR, (x, y), Rgb(r, 0, 0)
        Pset imgG, (x, y), Rgb(0, g, 0)
        Pset imgB, (x, y), Rgb(0, 0, b)
    Next x
Next y

'' Draw the image onto the screen using various blitting methods.
Put (  ancho+10, 0), imgR, Pset
Put (2*ancho+20, 0), imgG, Pset
Put (3*ancho+30, 0), imgB, Pset

'' Destroy the image.
Imagedestroy imgR : Imagedestroy imgG : Imagedestroy imgB

Sleep
