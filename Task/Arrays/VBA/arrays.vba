Sub matrix()
    'create an array,
    Dim a(3) As Integer
    Dim i As Integer
    'assign a value to it,
    For i = 1 To 3
        a(i) = i * i
    Next i
    'and retrieve an element
    For i = 1 To 3
        Debug.Print a(i)
    Next i
    'dynamic
    Dim d() As Integer
    ReDim d(3)
    For i = 1 To 3
        d(i) = i * i
    Next i
    'and retrieve an element
    For i = 1 To 3
        Debug.Print d(i)
    Next i
    'push a value to it - expand the array and preserve existing values
    ReDim Preserve d(4)
    d(4) = 16:
    For i = 1 To 4
        Debug.Print d(i)
    Next i
End Sub
