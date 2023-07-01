Const n = 2200
Public Sub pq()
    Dim s As Long, s1 As Long, s2 As Long, x As Long, x2 As Long, y As Long: s = 3
    Dim l(n) As Boolean, l_add(9680000) As Boolean '9680000=n * n * 2
    For x = 1 To n
        x2 = x * x
        For y = x To n
            l_add(x2 + y * y) = True
        Next y
    Next x
    For x = 1 To n
        s1 = s
        s = s + 2
        s2 = s
        For y = x + 1 To n
            If l_add(s1) Then l(y) = True
            s1 = s1 + s2
            s2 = s2 + 2
        Next
    Next
    For x = 1 To n
        If Not l(x) Then Debug.Print x;
    Next
    Debug.Print
End Sub
