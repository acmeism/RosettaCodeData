Private Function call_fn(f As String, n As Long) As Long
    call_fn = Application.Run(f, f, n)
End Function

Private Function Y(f As String) As String
    Y = f
End Function

Private Function fac(self As String, n As Long) As Long
    If n > 1 Then
        fac = n * call_fn(self, n - 1)
    Else
        fac = 1
    End If
End Function

Private Function fib(self As String, n As Long) As Long
    If n > 1 Then
        fib = call_fn(self, n - 1) + call_fn(self, n - 2)
    Else
        fib = n
    End If
End Function

Private Sub test(name As String)
    Dim f As String: f = Y(name)
    Dim i As Long
    Debug.Print name
    For i = 1 To 10
        Debug.Print call_fn(f, i);
    Next i
    Debug.Print
End Sub

Public Sub main()
    test "fac"
    test "fib"
End Sub
