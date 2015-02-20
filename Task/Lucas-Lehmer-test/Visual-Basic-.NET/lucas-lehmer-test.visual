Public Class LucasLehmer
    Private Sub btnGo_Click(sender As Object, e As EventArgs) Handles btnGo.Click
        Const iexpmax = 31
        Dim s, n As Long
        Dim i, iexp As Integer
        n = 1
        txtOut.Text = ""
        For iexp = 2 To iexpmax
            If iexp = 2 Then
                s = 0
            Else
                s = 4
            End If
            n = (n + 1) * 2 - 1
            For i = 1 To iexp - 2
                s = (s * s - 2) Mod n
            Next i
            If s = 0 Then
                txtOut.Text = txtOut.Text & "M" & iexp & " "
            End If
        Next iexp
    End Sub
End Class
