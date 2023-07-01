Sub QuickSort(arr() As Integer, ByVal f As Integer, ByVal l As Integer)
    i = f 'First
    j = l 'Last
    Key = arr(i) 'Pivot
    Do While i < j
        Do While i < j And Key < arr(j)
            j = j - 1
        Loop
        If i < j Then arr(i) = arr(j): i = i + 1
        Do While i < j And Key > arr(i)
            i = i + 1
        Loop
        If i < j Then arr(j) = arr(i): j = j - 1
    Loop
    arr(i) = Key
    If i - 1 > f Then QuickSort arr(), f, i - 1
    If j + 1 < l Then QuickSort arr(), j + 1, l
End Sub
