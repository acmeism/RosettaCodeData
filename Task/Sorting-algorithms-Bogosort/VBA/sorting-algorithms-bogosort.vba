Private Function Knuth(a As Variant) As Variant
    Dim t As Variant, i As Integer
    If Not IsMissing(a) Then
        For i = UBound(a) To LBound(a) + 1 Step -1
            j = Int((UBound(a) - LBound(a) + 1) * Rnd + LBound(a))
            t = a(i)
            a(i) = a(j)
            a(j) = t
        Next i
    End If
    Knuth = a
End Function

Private Function inOrder(s As Variant)
    i = 2
    Do While i <= UBound(s)
         If s(i) < s(i - 1) Then
            inOrder = False
            Exit Function
        End If
        i = i + 1
    Loop
    inOrder = True
End Function

Private Function bogosort(ByVal s As Variant) As Variant
    Do While Not inOrder(s)
        Debug.Print Join(s, ", ")
        s = Knuth(s)
    Loop
    bogosort = s
End Function

Public Sub main()
    Debug.Print Join(bogosort(Knuth([{1,2,3,4,5,6}])), ", ")
End Sub
