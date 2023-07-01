Private Function ffr(n As Long) As Long
    Dim R As New Collection
    Dim S As New Collection
    R.Add 1
    S.Add 2
    'return R(n)
    For i = 2 To n
        R.Add R(i - 1) + S(i - 1)
        For j = S(S.Count) + 1 To R(i) - 1
            S.Add j
        Next j
        For j = R(i) + 1 To R(i) + S(i - 1)
            S.Add j
        Next j
    Next i
    ffr = R(n)
    Set R = Nothing
    Set S = Nothing
End Function
Private Function ffs(n As Long) As Long
    Dim R As New Collection
    Dim S As New Collection
    R.Add 1
    S.Add 2
    'return S(n)
    For i = 2 To n
        R.Add R(i - 1) + S(i - 1)
        For j = S(S.Count) + 1 To R(i) - 1
            S.Add j
        Next j
        For j = R(i) + 1 To R(i) + S(i - 1)
            S.Add j
        Next j
        If S.Count >= n Then Exit For
    Next i
    ffs = S(n)
    Set R = Nothing
    Set S = Nothing
End Function
Public Sub main()
    Dim i As Long
    Debug.Print "The first ten values of R are:"
    For i = 1 To 10
        Debug.Print ffr(i);
    Next i
    Debug.Print
    Dim x As New Collection
    For i = 1 To 1000
        x.Add i, CStr(i)
    Next i
    For i = 1 To 40
        x.Remove CStr(ffr(i))
    Next i
    For i = 1 To 960
        x.Remove CStr(ffs(i))
    Next i
    Debug.Print "The first 40 values of ffr plus the first 960 values of ffs "
    Debug.Print "include all the integers from 1 to 1000 exactly once is "; Format(x.Count = 0)
End Sub
