' Munching squares - 27/07/2018
Public Class MunchingSquares
    Const xsize = 256
    Dim BMP As New Drawing.Bitmap(xsize, xsize)
    Dim GFX As Graphics = Graphics.FromImage(BMP)

    Private Sub MunchingSquares_Paint(sender As Object, e As PaintEventArgs) Handles Me.Paint
        'draw
        Dim MyGraph As Graphics = Me.CreateGraphics
        Dim nColor As Color
        Dim i, j, cp As Integer
        xPictureBox.Image = BMP
        For i = 0 To xsize - 1
            For j = 0 To xsize - 1
                cp = i Xor j
                nColor = Color.FromArgb(cp, 0, cp)
                BMP.SetPixel(i, j, nColor)
            Next j
        Next i
    End Sub 'Paint

End Class
