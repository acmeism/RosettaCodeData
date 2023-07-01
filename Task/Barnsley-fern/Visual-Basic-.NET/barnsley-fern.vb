' Barnsley Fern - 11/11/2019
Public Class BarnsleyFern

    Private Sub BarnsleyFern_Paint(sender As Object, e As PaintEventArgs) Handles Me.Paint
        Const Height = 800
        Dim x, y, xn, yn As Double
        Dim f As Double = Height / 10.6
        Dim offset_x As UInteger = Height \ 4 - Height \ 40
        Dim n, r As UInteger
        Dim Bmp As New Drawing.Bitmap(Height \ 2, Height) 'x,y
	'In Form: xPictureBox As PictureBox(800,400)
        xPictureBox.Image = Bmp
        For n = 1 To Height * 50
            r = Int(Rnd() * 100)      ' f from 0 to 99
            Select Case r
                Case 0 To 84
                    xn = 0.85 * x + 0.04 * y
                    yn = -0.04 * x + 0.85 * y + 1.6
                Case 85 To 91
                    xn = 0.2 * x - 0.26 * y
                    yn = 0.23 * x + 0.22 * y + 1.6
                Case 92 To 98
                    xn = -0.15 * x + 0.28 * y
                    yn = 0.26 * x + 0.24 * y + 0.44
                Case Else
                    xn = 0
                    yn = 0.16 * y
            End Select
            x = xn : y = yn
            Bmp.SetPixel(offset_x + x * f, Height - y * f, Color.FromArgb(0, 255, 0)) 'x,y  'r,g,b
        Next n
    End Sub 'Paint

End Class 'BarnsleyFern
