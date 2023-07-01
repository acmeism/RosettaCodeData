Private Function nth_root(y As Double, n As Double)
    Dim eps As Double: eps = 0.00000000000001 '-- relative accuracy
    Dim x As Variant: x = 1
    Do While True
        d = (y / x ^ (n - 1) - x) / n
        x = x + d
        e = eps * x '-- absolute accuracy
        If d > -e And d < e Then
            Exit Do
        End If
    Loop
    Debug.Print y; n; x; y ^ (1 / n)
End Function
Public Sub main()
    nth_root 1024, 10
    nth_root 27, 3
    nth_root 2, 2
    nth_root 5642, 125
    nth_root 7, 0.5
    nth_root 4913, 3
    nth_root 8, 3
    nth_root 16, 2
    nth_root 16, 4
    nth_root 125, 3
    nth_root 1000000000, 3
    nth_root 1000000000, 9
End Sub
