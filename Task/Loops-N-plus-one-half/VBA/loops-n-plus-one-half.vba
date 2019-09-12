Public Sub WriteACommaSeparatedList()
    Dim i As Integer
    Dim a(1 To 10) As String
    For i = 1 To 10
        a(i) = CStr(i)
    Next i
    Debug.Print Join(a, ", ")
End Sub
