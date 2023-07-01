Public Class Main
    Inherits System.Windows.Forms.Form
    Public Sub New()
        Me.FormBorderStyle = FormBorderStyle.None
        Me.WindowState = FormWindowState.Maximized
    End Sub
    Private Sub Main_Load(sender As Object, e As EventArgs) Handles Me.Load
        Dim Index As Integer
        Dim Colors() As Color = {Color.Black, Color.Red, Color.Green, Color.Magenta, Color.Cyan, Color.Yellow, Color.White}
        Dim Height = (Me.ClientSize.Height / 4) + 1
        For y = 1 To 4
            Dim Top = Me.ClientSize.Height / 4 * (y - 1)
            For x = 0 To Me.ClientSize.Width Step y
                If Index = 6 Then Index = 0 Else Index += 1
                Me.Controls.Add(New Panel With {.Top = Top, .Height = Height, .Left = x, .Width = y, .BackColor = Colors(Index)})
            Next
        Next
    End Sub
End Class
