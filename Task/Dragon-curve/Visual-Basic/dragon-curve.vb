Option Explicit
Const Pi As Double = 3.14159265358979
Dim angle As Double
Dim nDepth As Integer
Dim nColor As Long

Private Sub Form_Load()
    nColor = vbBlack
    nDepth = 12
    DragonCurve
End Sub

Sub DragonProc(size As Double, ByVal split As Integer, d As Integer)
    If split = 0 Then
     xForm.Line -Step(-Cos(angle) * size, Sin(angle) * size), nColor
    Else
        angle = angle + d * Pi / 4
        Call DragonProc(size / Sqr(2), split - 1, 1)
        angle = angle - d * Pi / 2
        Call DragonProc(size / Sqr(2), split - 1, -1)
        angle = angle + d * Pi / 4
    End If
End Sub

Sub DragonCurve()
    Const xcoefi = 0.74
    Const xcoefl = 0.59
    xForm.PSet (xForm.Width * xcoefi, xForm.Height / 3), nColor
    Call DragonProc(xForm.Width * xcoefl, nDepth, 1)
End Sub
