Private Function zeckendorf(ByVal n As Integer) As Integer
    Dim r As Integer: r = 0
    Dim c As Integer
    Dim fib As New Collection
    fib.Add 1
    fib.Add 1
    Do While fib(fib.Count) < n
        fib.Add fib(fib.Count - 1) + fib(fib.Count)
    Loop
    For i = fib.Count To 2 Step -1
        c = n >= fib(i)
        r = r + r - c
        n = n + c * fib(i)
    Next i
    zeckendorf = r
End Function

Public Sub main()
    Dim i As Integer
    For i = 0 To 20
        Debug.Print Format(i, "@@"); ":"; Format(WorksheetFunction.Dec2Bin(zeckendorf(i)), "@@@@@@@")
    Next i
End Sub
