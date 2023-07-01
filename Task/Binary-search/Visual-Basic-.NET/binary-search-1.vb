Function BinarySearch(ByVal A() As Integer, ByVal value As Integer) As Integer
    Dim low As Integer = 0
    Dim high As Integer = A.Length - 1
    Dim middle As Integer = 0

    While low <= high
        middle = (low + high) / 2
        If A(middle) > value Then
            high = middle - 1
        ElseIf A(middle) < value Then
            low = middle + 1
        Else
            Return middle
        End If
    End While

    Return Nothing
End Function
