Private Function gnomeSort(s As Variant) As Variant
    Dim i As Integer: i = 1
    Dim j As Integer: j = 2
    Dim tmp As Integer
    Do While i < UBound(s)
        If s(i) <= s(i + 1) Then
            i = j
            j = j + 1
        Else
            tmp = s(i)
            s(i) = s(i + 1)
            s(i + 1) = tmp
            i = i - 1
            If i = 0 Then
                i = j
                j = j + 1
            End If
        End If
    Loop
    gnomeSort = s
End Function

Public Sub main()
    Debug.Print Join(gnomeSort([{5, 3, 1, 7, 4, 1, 1, 20}]), ", ")
End Sub
