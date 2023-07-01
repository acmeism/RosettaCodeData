Sub AplusB()
    Dim s As String, t As Variant, a As Integer, b As Integer
    s = InputBox("Enter two numbers separated by a space")
    t = Split(s)
    a = CInt(t(0))
    b = CInt(t(1))
    MsgBox a + b
End Sub
