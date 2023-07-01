Function BinarySearch(ByVal A() As Integer, ByVal value As Integer, ByVal low As Integer, ByVal high As Integer) As Integer
    Dim middle As Integer = 0

    If high < low Then
        Return Nothing
    End If

    middle = (low + high) / 2

    If A(middle) > value Then
        Return BinarySearch(A, value, low, middle - 1)
    ElseIf A(middle) < value Then
        Return BinarySearch(A, value, middle + 1, high)
    Else
        Return middle
    End If
End Function
