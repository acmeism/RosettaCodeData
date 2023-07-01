Private Function hailstone(ByVal n As Long) As Collection
    Dim s As New Collection
    s.Add CStr(n), CStr(n)
    i = 0
    Do While n <> 1
        If n Mod 2 = 0 Then
            n = n / 2
        Else
            n = 3 * n + 1
        End If
        s.Add CStr(n), CStr(n)
    Loop
    Set hailstone = s
End Function

Private Function hailstone_count(ByVal n As Long)
    Dim count As Long: count = 1
    Do While n <> 1
        If n Mod 2 = 0 Then
            n = n / 2
        Else
            n = 3 * n + 1
        End If
        count = count + 1
    Loop
    hailstone_count = count
End Function

Public Sub rosetta()
    Dim s As Collection, i As Long
    Set s = hailstone(27)
    Dim ls As Integer: ls = s.count
    Debug.Print "hailstone(27) = ";
    For i = 1 To 4
        Debug.Print s(i); ", ";
    Next i
    Debug.Print "... ";
    For i = s.count - 4 To s.count - 1
        Debug.Print s(i); ", ";
    Next i
    Debug.Print s(s.count)
    Debug.Print "length ="; ls
    Dim hmax As Long: hmax = 1
    Dim imax As Long: imax = 1
    Dim count As Integer
    For i = 2 To 100000# - 1
        count = hailstone_count(i)
        If count > hmax Then
            hmax = count
            imax = i
        End If
    Next i
    Debug.Print "The longest hailstone sequence under 100,000 is"; imax; "with"; hmax; "elements."
End Sub
