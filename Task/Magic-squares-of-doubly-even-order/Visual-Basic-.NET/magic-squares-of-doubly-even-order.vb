Module MagicSquares

    Function MagicSquareDoublyEven(n As Integer) As Integer(,)
        If n < 4 OrElse n Mod 4 <> 0 Then
            Throw New ArgumentException("base must be a positive multiple of 4")
        End If

        'pattern of count-up vs count-down zones
        Dim bits = Convert.ToInt32("1001011001101001", 2)
        Dim size = n * n
        Dim mult As Integer = n / 4 ' how many multiples of 4

        Dim result(n - 1, n - 1) As Integer

        Dim i = 0
        For r = 0 To n - 1
            For c = 0 To n - 1
                Dim bitPos As Integer = Math.Floor(c / mult) + Math.Floor(r / mult) * 4
                Dim test = (bits And (1 << bitPos)) <> 0
                If test Then
                    result(r, c) = i + 1
                Else
                    result(r, c) = size - i
                End If

                i = i + 1
            Next
            Console.WriteLine()
        Next

        Return result
    End Function

    Sub Main()
        Dim n = 8
        Dim result = MagicSquareDoublyEven(n)
        For i = 0 To result.GetLength(0) - 1
            For j = 0 To result.GetLength(1) - 1
                Console.Write("{0,2} ", result(i, j))
            Next
            Console.WriteLine()
        Next
        Console.WriteLine()
        Console.WriteLine("Magic constant: {0} ", (n * n + 1) * n / 2)

        Console.ReadLine()
    End Sub

End Module
