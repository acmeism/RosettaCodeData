WindowTitle "Color separation, CMY model improved 1.0"
Dim As String imagen =  "lena.bmp"
Dim As Long ancho, alto, f = FreeFile()
' open BMP file
Open imagen For Binary Access Read As #f
' retrieve BMP dimensions
Get #f, 19, ancho : Get #f, 23, alto
Close #f
' create image with BMP dimensions
Dim As Any Ptr img = ImageCreate(ancho, alto)
ScreenRes 40+(ancho*4), alto+10, 32

'draw original image
BLoad imagen

Dim As Integer y, x
Dim As ULong col, r, g, b

'' Create one pixel image for cada color.
Dim imgC As Any Ptr = ImageCreate(ancho, alto)
Dim imgM As Any Ptr = ImageCreate(ancho, alto)
Dim imgY As Any Ptr = ImageCreate(ancho, alto)
For y = 0 To alto-1
    For x = 0 To ancho-1
        col = Point(x,y)
        r = col Shr 16 And 255
        g = col Shr 8  And 255
        b = col        And 255
        PSet imgC, (x, y), RGB(r, 255, 255)
        PSet imgM, (x, y), RGB(255, g, 255)
        PSet imgY, (x, y), RGB(255, 255, b)
    Next x
Next y

'' Draw the image onto the screen using various blitting methods.
Put (  ancho+10, 0), imgC, PSet
Put (2*ancho+20, 0), imgM, PSet
Put (3*ancho+30, 0), imgY, PSet

'' Destroy the image.
ImageDestroy imgC : ImageDestroy imgM : ImageDestroy imgY

Sleep
