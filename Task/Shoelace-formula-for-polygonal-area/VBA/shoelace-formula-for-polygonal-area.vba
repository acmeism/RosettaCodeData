Option Base 1
Public Enum axes
    u = 1
    v
End Enum
Private Function shoelace(s As Collection) As Double
    Dim t As Double
    If s.Count > 2 Then
        s.Add s(1)
        For i = 1 To s.Count - 1
            t = t + s(i)(u) * s(i + 1)(v) - s(i + 1)(u) * s(i)(v)
        Next i
    End If
    shoelace = Abs(t) / 2
End Function

Public Sub polygonal_area()
    Dim task() As Variant
    task = [{3,4;5,11;12,8;9,5;5,6}]
    Dim tcol As New Collection
    For i = 1 To UBound(task)
        tcol.Add Array(task(i, u), task(i, v))
    Next i
    Debug.Print shoelace(tcol)
End Sub
