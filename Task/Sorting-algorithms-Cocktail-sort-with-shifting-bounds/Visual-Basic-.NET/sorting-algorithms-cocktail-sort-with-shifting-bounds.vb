' Sorting algorithms/Cocktail sort with shifting bounds - VB.Net
    Private Sub Cocktail_Shaker_Sort()
        Dim A(20), tmp As Long  'or Integer Long Single Double String
        Dim i, beginIdx, endIdx, newBeginIdx, newEndIdx As Integer
        'Generate the list
        For i = LBound(A) To UBound(A)
            A(i) = Int(Rnd() * 100)
        Next i
        'Sort the list
        beginIdx = LBound(A)
        endIdx = UBound(A) - 1
        Do While beginIdx <= endIdx
            newBeginIdx = endIdx
            newEndIdx = beginIdx
            For ii = beginIdx To endIdx
                If A(ii) > A(ii + 1) Then
                    tmp = A(ii) : A(ii) = A(ii + 1) : A(ii + 1) = tmp
                    newEndIdx = ii
                End If
            Next ii
            endIdx = newEndIdx - 1
            For ii = endIdx To beginIdx Step -1
                If A(ii) > A(ii + 1) Then
                    tmp = A(ii) : A(ii) = A(ii + 1) : A(ii + 1) = tmp
                    newBeginIdx = ii
                End If
            Next ii
            beginIdx = newBeginIdx + 1
        Loop
        'Display the sorted list
        Debug.Print(String.Join(", ", A))
    End Sub 'Cocktail_Shaker_Sort
