Imports System.Numerics

Module Module1

    Function Sqrt(x As BigInteger) As BigInteger
        If x < 0 Then
            Throw New ArgumentException("Negative argument.")
        End If
        If x < 2 Then
            Return x
        End If
        Dim y = x / 2
        While y > (x / y)
            y = ((x / y) + y) / 2
        End While
        Return y
    End Function

    Function IsPrime(bi As BigInteger) As Boolean
        If bi < 2 Then
            Return False
        End If
        If bi Mod 2 = 0 Then
            Return bi = 2
        End If
        If bi Mod 3 = 0 Then
            Return bi = 3
        End If
        If bi Mod 5 = 0 Then
            Return bi = 5
        End If
        If bi Mod 7 = 0 Then
            Return bi = 7
        End If
        If bi Mod 11 = 0 Then
            Return bi = 11
        End If
        If bi Mod 13 = 0 Then
            Return bi = 13
        End If
        If bi Mod 17 = 0 Then
            Return bi = 17
        End If
        If bi Mod 19 = 0 Then
            Return bi = 19
        End If

        Dim limit = Sqrt(bi)
        Dim test As BigInteger = 23
        While test < limit
            If bi Mod test = 0 Then
                Return False
            End If
            test += 2
            If bi Mod test = 0 Then
                Return False
            End If
            test += 4
        End While

        Return True
    End Function

    Sub Main()
        Const MAX = 9

        Dim pow = 2
        Dim count = 0

        While True
            If IsPrime(pow) Then
                Dim p = BigInteger.Pow(2, pow) - 1
                If IsPrime(p) Then
                    Console.WriteLine("2 ^ {0} - 1", pow)
                    count += 1
                    If count >= MAX Then
                        Exit While
                    End If
                End If
            End If
            pow += 1
        End While
    End Sub

End Module
