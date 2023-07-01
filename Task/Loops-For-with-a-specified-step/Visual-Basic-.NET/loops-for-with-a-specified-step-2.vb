Public Class FormPG
    Private Sub FormPG_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim i As Integer, buffer As String
        buffer = ""
        For i = 2 To 8 Step 2
            buffer = buffer & i & " "
        Next i
        Debug.Print(buffer)
    End Sub
End Class
