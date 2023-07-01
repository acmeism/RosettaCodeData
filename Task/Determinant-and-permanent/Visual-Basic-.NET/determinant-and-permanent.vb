Module Module1

    Function Minor(a As Double(,), x As Integer, y As Integer) As Double(,)
        Dim length = a.GetLength(0) - 1
        Dim result(length - 1, length - 1) As Double
        For i = 1 To length
            For j = 1 To length
                If i < x AndAlso j < y Then
                    result(i - 1, j - 1) = a(i - 1, j - 1)
                ElseIf i >= x AndAlso j < y Then
                    result(i - 1, j - 1) = a(i, j - 1)
                ElseIf i < x AndAlso j >= y Then
                    result(i - 1, j - 1) = a(i - 1, j)
                Else
                    result(i - 1, j - 1) = a(i, j)
                End If
            Next
        Next
        Return result
    End Function

    Function Det(a As Double(,)) As Double
        If a.GetLength(0) = 1 Then
            Return a(0, 0)
        Else
            Dim sign = 1
            Dim sum = 0.0
            For i = 1 To a.GetLength(0)
                sum += sign * a(0, i - 1) * Det(Minor(a, 0, i))
                sign *= -1
            Next
            Return sum
        End If
    End Function

    Function Perm(a As Double(,)) As Double
        If a.GetLength(0) = 1 Then
            Return a(0, 0)
        Else
            Dim sum = 0.0
            For i = 1 To a.GetLength(0)
                sum += a(0, i - 1) * Perm(Minor(a, 0, i))
            Next
            Return sum
        End If
    End Function

    Sub WriteLine(a As Double(,))
        For i = 1 To a.GetLength(0)
            Console.Write("[")
            For j = 1 To a.GetLength(1)
                If j > 1 Then
                    Console.Write(", ")
                End If
                Console.Write(a(i - 1, j - 1))
            Next
            Console.WriteLine("]")
        Next
    End Sub

    Sub Test(a As Double(,))
        If a.GetLength(0) <> a.GetLength(1) Then
            Throw New ArgumentException("The dimensions must be equal")
        End If

        WriteLine(a)
        Console.WriteLine("Permanant  : {0}", Perm(a))
        Console.WriteLine("Determinant: {0}", Det(a))
        Console.WriteLine()
    End Sub

    Sub Main()
        Test({{1, 2}, {3, 4}})
        Test({{1, 2, 3, 4}, {4, 5, 6, 7}, {7, 8, 9, 10}, {10, 11, 12, 13}})
        Test({{0, 1, 2, 3, 4}, {5, 6, 7, 8, 9}, {10, 11, 12, 13, 14}, {15, 16, 17, 18, 19}, {20, 21, 22, 23, 24}})
    End Sub

End Module
