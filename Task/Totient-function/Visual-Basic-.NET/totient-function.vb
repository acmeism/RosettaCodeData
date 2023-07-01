Imports System.Linq.Enumerable

Module Module1

    Sub Main()
        For i = 1 To 25
            Dim t = Totient(i)
            Console.WriteLine("{0}{1}{2}{3}", i, vbTab, t, If(t = i - 1, vbTab & "prime", ""))
        Next
        Console.WriteLine()

        Dim j = 100
        While j <= 100000
            Console.WriteLine($"{Range(1, j).Count(Function(x) Totient(x) + 1 = x):n0} primes below {j:n0}")
            j *= 10
        End While
    End Sub

    Function Totient(n As Integer) As Integer
        If n < 3 Then
            Return 1
        End If
        If n = 3 Then
            Return 2
        End If

        Dim tot = n

        If (n And 1) = 0 Then
            tot >>= 1
            Do
                n >>= 1
            Loop While (n And 1) = 0
        End If

        Dim i = 3
        While i * i <= n
            If n Mod i = 0 Then
                tot -= tot \ i
                Do
                    n \= i
                Loop While (n Mod i) = 0
            End If
            i += 2
        End While

        If n > 1 Then
            tot -= tot \ n
        End If

        Return tot
    End Function

End Module
