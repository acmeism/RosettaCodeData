Option Explicit
Function two_sum(a As Variant, t As Integer) As Variant
    Dim i, j As Integer
    i = 0
    j = UBound(a)
    Do While (i < j)
        If (a(i) + a(j) = t) Then
            two_sum = Array(i, j)
            Exit Function
        ElseIf (a(i) + a(j) < t) Then i = i + 1
        ElseIf (a(i) + a(j) > t) Then j = j - 1
        End If
    Loop
    two_sum = Array()
End Function
Sub prnt(a As Variant)
    If UBound(a) = 1 Then
        Selection.TypeText Text:="(" & a(0) & ", " & a(1) & ")" & vbCrLf
    Else
        Selection.TypeText Text:="()" & vbCrLf
    End If
End Sub
Sub main()
    Call prnt(two_sum(Array(0, 2, 11, 19, 90), 21))
    Call prnt(two_sum(Array(-8, -2, 0, 1, 5, 8, 11), 3))
    Call prnt(two_sum(Array(-3, -2, 0, 1, 5, 8, 11), 17))
    Call prnt(two_sum(Array(-8, -2, -1, 1, 5, 9, 11), 0))
End Sub
