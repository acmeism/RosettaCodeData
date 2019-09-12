Function heroArea(a As Integer, b As Integer, c As Integer) As Double
    s = (a + b + c) / 2
    On Error GoTo Err
    heroArea = Sqr(s * (s - a) * (s - b) * (s - c))
    Exit Function
Err:
    heroArea = -1
End Function

Function hero(h As Double) As Boolean
    hero = (h - Int(h) = 0) And h > 0
End Function

Public Sub main()
    Dim list() As Variant, items As Integer
    Dim a As Integer, b As Integer, c As Integer
    Dim hArea As Double
    Dim tries As Long
    For a = 1 To 200
        For b = 1 To a
            For c = 1 To b
                tries = tries + 1
                If gcd(gcd(a, b), c) = 1 Then
                    hArea = heroArea(a, b, c)
                    If hero(hArea) Then
                        ReDim Preserve list(items)
                        list(items) = Array(CStr(hArea), CStr(a + b + c), CStr(a), CStr(b), CStr(c))
                        items = items + 1
                    End If
                End If
            Next c
        Next b
    Next a
    list = sort(list)
    Debug.Print "Primitive Heronian triangles with sides up to 200:"; UBound(list) + 1; "(of"; tries; "tested)"
    Debug.Print
    Debug.Print "First 10 ordered by area/perimeter/sides:"
    Debug.Print "area       perimeter        sides"
    For i = 0 To 9
        Debug.Print Format(list(i)(0), "@@@"), Format(list(i)(1), "@@@"),
        Debug.Print list(i)(2); "x"; list(i)(3); "x"; list(i)(4)
    Next i
    Debug.Print
    Debug.Print "area = 210:"
    Debug.Print "area       perimeter        sides"
    For i = 0 To UBound(list)
        If Val(list(i)(0)) = 210 Then
            Debug.Print Format(list(i)(0), "@@@"), Format(list(i)(1), "@@@"),
            Debug.Print list(i)(2); "x"; list(i)(3); "x"; list(i)(4)
        End If
    Next i
End Sub
