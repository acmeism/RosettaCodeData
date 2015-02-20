Option Explicit On
Imports System.Math

Public Class DragonCurve
    Dim nDepth As Integer = 12
    Dim angle As Double
    Dim MouseX, MouseY As Integer
    Dim CurrentX, CurrentY As Integer
    Dim nColor As Color = Color.Black

    Private Sub DragonCurve_Click(sender As Object, e As EventArgs) Handles Me.Click
        SubDragonCurve()
    End Sub

    Sub DrawClear()
        Me.CreateGraphics.Clear(Color.White)
    End Sub

    Sub DrawMove(ByVal X As Double, ByVal Y As Double)
        CurrentX = X
        CurrentY = Y
    End Sub

    Sub DrawLine(ByVal X As Double, ByVal Y As Double)
        Dim MyGraph As Graphics = Me.CreateGraphics
        Dim PenColor As Pen = New Pen(nColor)
        Dim NextX, NextY As Long
        NextX = CurrentX + X
        NextY = CurrentY + Y
        MyGraph.DrawLine(PenColor, CurrentX, CurrentY, NextX, NextY)
        CurrentX = NextX
        CurrentY = NextY
    End Sub

    Sub DragonProc(size As Double, ByVal split As Integer, d As Integer)
        If split = 0 Then
            DrawLine(-Cos(angle) * size, Sin(angle) * size)
        Else
            angle = angle + d * PI / 4
            DragonProc(size / Sqrt(2), split - 1, 1)
            angle = angle - d * PI / 2
            DragonProc(size / Sqrt(2), split - 1, -1)
            angle = angle + d * PI / 4
        End If
    End Sub

    Sub SubDragonCurve()
        Const xcoefi = 0.74, xcoefl = 0.59
        DrawClear()
        DrawMove(Me.Width * xcoefi, Me.Height / 3)
        DragonProc(Me.Width * xcoefl, nDepth, 1)
    End Sub

End Class
