Dim n As Integer, c As Integer
Dim a() As Integer

Private Sub Command1_Click()
    Dim res As Integer
    If c < n Then Label3.Caption = "Please input completely.": Exit Sub
    res = getLantern(a())
    Label3.Caption = "Result：" + Str(res)
End Sub

Private Sub Text1_Change()
    If Val(Text1.Text) <> 0 Then
        n = Val(Text1.Text)
        ReDim a(1 To n) As Integer
    End If
End Sub


Private Sub Text2_KeyPress(KeyAscii As Integer)
    If KeyAscii = Asc(vbCr) Then
        If Val(Text2.Text) = 0 Then Exit Sub
        c = c + 1
        If c > n Then Exit Sub
        a(c) = Val(Text2.Text)
        List1.AddItem Str(a(c))
        Text2.Text = ""
    End If
End Sub

Function getLantern(arr() As Integer) As Integer
    Dim res As Integer, i As Integer
    For i = 1 To n
        If arr(i) <> 0 Then
            arr(i) = arr(i) - 1
            res = res + getLantern(arr())
            arr(i) = arr(i) + 1
        End If
    Next i
    If res = 0 Then res = 1
    getLantern = res
End Function
