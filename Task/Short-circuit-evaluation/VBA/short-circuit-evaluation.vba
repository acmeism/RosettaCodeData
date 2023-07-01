Private Function a(i As Variant) As Boolean
    Debug.Print "a:  "; i = 1,
    a = i
End Function
Private Function b(j As Variant) As Boolean
    Debug.Print "b: "; j = 1;
    b = j
End Function
Public Sub short_circuit()
    Dim x As Boolean, y As Boolean
    'Dim p As Boolean, q As Boolean
    Debug.Print "=====AND=====" & vbCrLf
    For p = 0 To 1
        For q = 0 To 1
            If a(p) Then
                x = b(q)
            End If
            Debug.Print " = x"
        Next q
        Debug.Print
    Next p
    Debug.Print "======OR=====" & vbCrLf
    For p = 0 To 1
        For q = 0 To 1
            If Not a(p) Then
                x = b(q)
            End If
            Debug.Print " = x"
        Next q
        Debug.Print
    Next p
    Debug.Print
End Sub
