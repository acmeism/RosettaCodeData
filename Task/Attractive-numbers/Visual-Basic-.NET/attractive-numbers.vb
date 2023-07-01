Module Module1
    Const MAX = 120

    Function IsPrime(n As Integer) As Boolean
        If n < 2 Then Return False
        If n Mod 2 = 0 Then Return n = 2
        If n Mod 3 = 0 Then Return n = 3
        Dim d = 5
        While d * d <= n
            If n Mod d = 0 Then Return False
            d += 2
            If n Mod d = 0 Then Return False
            d += 4
        End While
        Return True
    End Function

    Function PrimefactorCount(n As Integer) As Integer
        If n = 1 Then Return 0
        If IsPrime(n) Then Return 1
        Dim count = 0
        Dim f = 2
        While True
            If n Mod f = 0 Then
                count += 1
                n /= f
                If n = 1 Then Return count
                If IsPrime(n) Then f = n
            ElseIf f >= 3 Then
                f += 2
            Else
                f = 3
            End If
        End While
        Throw New Exception("Unexpected")
    End Function

    Sub Main()
        Console.WriteLine("The attractive numbers up to and including {0} are:", MAX)
        Dim i = 1
        Dim count = 0
        While i <= MAX
            Dim n = PrimefactorCount(i)
            If IsPrime(n) Then
                Console.Write("{0,4}", i)
                count += 1
                If count Mod 20 = 0 Then
                    Console.WriteLine()
                End If
            End If
                i += 1
        End While
        Console.WriteLine()
    End Sub

End Module
