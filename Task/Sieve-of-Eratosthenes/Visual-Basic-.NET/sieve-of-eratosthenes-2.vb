Module Module1
    Sub Main(args() As String)
        Dim lmt As Integer = 500, n As Integer = 2, k As Integer
        If args.Count > 0 Then Integer.TryParse(args(0), lmt)
        Dim flags(lmt + 1) As Boolean   ' non-primes are true in this array.
        Do                              ' a prime was found,
            Console.Write($"{n} ")      ' so show it,
            For k = n * n To lmt Step n ' and eliminate any multiple of it at it's square and beyond.
                flags(k) = True
            Next
            Do                          ' skip over non-primes.
                n += If(n = 2, 1, 2)
            Loop While flags(n)
        Loop while n <= lmt
    End Sub
End Module
