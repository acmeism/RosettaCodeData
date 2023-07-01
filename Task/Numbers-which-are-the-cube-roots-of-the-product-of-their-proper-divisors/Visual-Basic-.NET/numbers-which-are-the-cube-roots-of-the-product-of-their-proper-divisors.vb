Imports System

Module Module1
    Function dc8(ByVal n As Integer) As Boolean
        Dim count, p, d As Integer, res As Integer = 1
        While (n And 1) = 0 : n >>= 1 : res += 1 :  End While
        count = 1 : While n Mod 3 = 0 : n \= 3 : count += 1 : End While
        p = 5 : d = 4 : While p * p <= n
            res *= count : count = 1
            While n Mod p = 0 : n \= p : count += 1 : End While
            d = 6 - d : p += d
        End While
        If n > 1 Then Return res * count = 4
        Return res * count = 8
    End Function

    Sub Main(ByVal args As String())
        Console.WriteLine("First 50 numbers which are the cube roots of the products of " _
                          & "their proper divisors:")
        Dim n As Integer = 1, count As Integer = 0, lmt As Integer = 500
        While count < 5e6
            If n = 1 OrElse dc8(n) Then
                count += 1 : If count <= 50 Then
                    Console.Write("{0,3}{1}", n, If(count Mod 10 = 0, vbLf, " "))
                ElseIf count = lmt Then
                    Console.Write("{0,16:n0}th: {1:n0}" & vbLf, count, n) : lmt *= 10
                End If
            End If
            n += 1
        End While
    End Sub
End Module
