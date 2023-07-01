Public Q(100000) As Long
Public Sub HofstadterQ()
    Dim n As Long, smaller As Long
    Q(1) = 1
    Q(2) = 1
    For n = 3 To 100000
        Q(n) = Q(n - Q(n - 1)) + Q(n - Q(n - 2))
        If Q(n) < Q(n - 1) Then smaller = smaller + 1
    Next n
    Debug.Print "First ten terms:"
    For i = 1 To 10
        Debug.Print Q(i);
    Next i
    Debug.print
    Debug.Print "The 1000th term is:"; Q(1000)
    Debug.Print "Number of times smaller:"; smaller
End Sub
