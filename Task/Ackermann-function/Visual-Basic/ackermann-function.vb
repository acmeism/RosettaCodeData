Option Explicit
Dim calls As Long
Sub main()
    Const maxi = 4
    Const maxj = 9
    Dim i As Long, j As Long
    For i = 0 To maxi
        For j = 0 To maxj
            Call print_acker(i, j)
        Next j
    Next i
End Sub 'main
Sub print_acker(m As Long, n As Long)
    calls = 0
    Debug.Print "ackermann("; m; ","; n; ")=";
    Debug.Print ackermann(m, n), "calls="; calls
End Sub 'print_acker
Function ackermann(m As Long, n As Long) As Long
    calls = calls + 1
    If m = 0 Then
        ackermann = n + 1
    Else
        If n = 0 Then
            ackermann = ackermann(m - 1, 1)
        Else
            ackermann = ackermann(m - 1, ackermann(m, n - 1))
        End If
    End If
End Function 'ackermann
