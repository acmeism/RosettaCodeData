' Sorting algorithms/Cocktail sort with shifting bounds - VBA

Function cocktailShakerSort(ByVal A As Variant) As Variant
    beginIdx = LBound(A)
    endIdx = UBound(A) - 1
    Do While beginIdx <= endIdx
        newBeginIdx = endIdx
        newEndIdx = beginIdx
        For ii = beginIdx To endIdx
            If A(ii) > A(ii + 1) Then
                tmp = A(ii): A(ii) = A(ii + 1): A(ii + 1) = tmp
                newEndIdx = ii
            End If
        Next ii
        endIdx = newEndIdx - 1
        For ii = endIdx To beginIdx Step -1
            If A(ii) > A(ii + 1) Then
                tmp = A(ii): A(ii) = A(ii + 1): A(ii + 1) = tmp
                newBeginIdx = ii
            End If
        Next ii
        beginIdx = newBeginIdx + 1
    Loop
    cocktailShakerSort = A
End Function 'cocktailShakerSort

Public Sub main()
    Dim B(20) As Variant
    For i = LBound(B) To UBound(B)
        B(i) = Int(Rnd() * 100)
    Next i
    Debug.Print Join(B, ", ")
    Debug.Print Join(cocktailShakerSort(B), ", ")
End Sub
