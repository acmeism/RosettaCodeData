Const limit = 31

Sub Riordan (n As Integer, a() As Integer)
    If n >= 0 Then
        a(0) = 1
        If n >= 1 Then
            a(1) = 0
            For i As Integer = 2 To n
                a(i) = ((i-1) * ((2 * a(i-1)) + (3 * a(i-2)))) / (i+1)
            Next i
        End If
    End If
End Sub

Dim As Integer r(0 To limit)
Dim As Byte cont = 0
Print "First 32 Riordan numbers:"
Riordan(limit, r())
For i As Integer = 0 To limit
    Print Using "  #############"; r(i);
    cont += 1
    If cont Mod 4 = 0 Then Print
Next i
Sleep
