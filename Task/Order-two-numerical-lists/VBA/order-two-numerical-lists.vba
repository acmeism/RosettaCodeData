Private Function order(list1 As Variant, list2 As Variant) As Boolean
    i = 1
    Do While list1(i) <= list2(i)
        i = i + 1
        If i > UBound(list1) Then
            order = True
            Exit Function
        End If
        If i > UBound(list2) Then
            order = False
            Exit Function
        End If
    Loop
    order = False
End Function
Public Sub main()
    Debug.Print order([{1, 2, 3, 4}], [{1,2,0,1,2}])
    Debug.Print order([{1, 2, 3, 4}], [{1,2,3}])
    Debug.Print order([{1, 2, 3}], [{1,2,3,4}])
End Sub
