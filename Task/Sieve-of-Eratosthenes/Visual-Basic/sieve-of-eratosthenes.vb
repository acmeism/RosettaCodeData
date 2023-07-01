Sub Eratost()
    Dim sieve() As Boolean
    Dim n As Integer, i As Integer, j As Integer
    n = InputBox("limit:", n)
    ReDim sieve(n)
    For i = 1 To n
        sieve(i) = True
    Next i
    For i = 2 To n
        If sieve(i) Then
            For j = i * 2 To n Step i
                sieve(j) = False
            Next j
        End If
    Next i
    For i = 2 To n
        If sieve(i) Then Debug.Print i
    Next i
End Sub 'Eratost
