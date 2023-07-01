Const Order = 4

Function InCarpet(ByVal x As Integer, ByVal y As Integer)
    Do While x <> 0 And y <> 0
        If x Mod 3 = 1 And y Mod 3 = 1 Then
            InCarpet = " "
            Exit Function
        End If
        x = x \ 3
        y = y \ 3
    Loop
    InCarpet = "#"
End Function

Public Sub sierpinski_carpet()
    Dim i As Integer, j As Integer
    For i = 0 To 3 ^ Order - 1
        For j = 0 To 3 ^ Order - 1
            Debug.Print InCarpet(i, j);
        Next j
        Debug.Print
    Next i
End Sub
