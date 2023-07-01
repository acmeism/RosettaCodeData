Private Function sumto(n As Integer) As Double
    Dim res As Double
    For i = 1 To n
        res = res + 1 / i ^ 2
    Next i
    sumto = res
End Function
Public Sub main()
    Debug.Print sumto(1000)
End Sub
