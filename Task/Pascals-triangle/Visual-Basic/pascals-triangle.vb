Sub pascaltriangle()
    'Pascal's triangle
    Const m = 11
    Dim t(40) As Integer, u(40) As Integer
    Dim i As Integer, n As Integer, s As String, ss As String
    ss = ""
    For n = 1 To m
        u(1) = 1
        s = ""
        For i = 1 To n
            u(i + 1) = t(i) + t(i + 1)
            s = s & u(i) & " "
            t(i) = u(i)
        Next i
        ss = ss & s & vbCrLf
    Next n
    MsgBox ss, , "Pascal's triangle"
End Sub 'pascaltriangle
