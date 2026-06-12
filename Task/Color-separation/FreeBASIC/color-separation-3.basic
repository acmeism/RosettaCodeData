#define min(a, b) iif((a) < (b), (a), (b))

WindowTitle "Color separation, CMYK model improved 1.0"
Dim As String imagen = "lady.bmp"
Dim As Long ancho, alto, f = FreeFile()
' open BMP file
Open imagen For Binary Access Read As #f
' retrieve BMP dimensions
Get #f, 19, ancho : Get #f, 23, alto
Close #f
' create image with BMP dimensions

Dim As Any Ptr img = ImageCreate(ancho, alto)
ScreenRes 50 + (ancho * 4), 20 + (alto * 2), 32
'draw original image
BLoad imagen

Dim As Integer i, j
Dim As ULong col, c, m, y, k, kc, rc, bc, gc

'' Create one pixel image for cada color.
Dim imgC As Any Ptr = ImageCreate(ancho, alto)
Dim imgM As Any Ptr = ImageCreate(ancho, alto)
Dim imgY As Any Ptr = ImageCreate(ancho, alto)
Dim imgk As Any Ptr = ImageCreate(ancho, alto)

For i = 0 To alto-1
    For j = 0 To ancho-1

        col = Point(j,i,img)
        rc = 255 - col Shr 16 And 255
        gc = 255 - col Shr 8  And 255
        bc = 255 - col        And 255
        k = min(min(rc, gc), bc)
        kc = 255 - k

        If k <> 255 Then
            c = (rc - k) * 255 \ kc
            m = (gc - k) * 255 \ kc
            y = (bc - k) * 255 \ kc
            PSet imgC, (j, i), RGB(255 - c, 255, 255)
            PSet imgM, (j, i), RGB(255, 255 - m, 255)
            PSet imgY, (j, i), RGB(255, 255, 255 - y)
        Else
            PSet imgC, (j, i), RGB(255, 255, 255)
            PSet imgM, (j, i), RGB(255, 255, 255)
            PSet imgY, (j, i), RGB(255, 255, 255)
        End If
        PSet imgK, (j, i), RGB(kc, kc, kc)

    Next j
Next i

'' Draw the image onto the screen using various blitting methods.
Put (            10, alto + 10), imgC, PSet
Put (    ancho + 20, alto + 10), imgM, PSet
Put (2 * ancho + 30, alto + 10), imgY, PSet
Put (3 * ancho + 40, alto + 10), imgK, PSet

'' Destroy the image.
Imagedestroy imgC : Imagedestroy imgM : Imagedestroy imgY : Imagedestroy imgk

Sleep
