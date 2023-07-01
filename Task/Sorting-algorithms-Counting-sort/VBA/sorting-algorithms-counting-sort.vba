Option Base 1
Private Function countingSort(array_ As Variant, mina As Long, maxa As Long) As Variant
    Dim count() As Integer
    ReDim count(maxa - mina + 1)
    For i = 1 To UBound(array_)
        count(array_(i) - mina + 1) = count(array_(i) - mina + 1) + 1
    Next i
    Dim z As Integer: z = 1
    For i = mina To maxa
        For j = 1 To count(i - mina + 1)
            array_(z) = i
            z = z + 1
        Next j
    Next i
    countingSort = array_
End Function

Public Sub main()
    s = [{5, 3, 1, 7, 4, 1, 1, 20}]
    Debug.Print Join(countingSort(s, WorksheetFunction.Min(s), WorksheetFunction.Max(s)), ", ")
End Sub
