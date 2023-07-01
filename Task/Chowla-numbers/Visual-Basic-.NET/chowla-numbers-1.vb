Imports System

Module Program
    Function chowla(ByVal n As Integer) As Integer
        chowla = 0 : Dim j As Integer, i As Integer = 2
        While i * i <= n
            j = n / i : If n Mod i = 0 Then chowla += i + (If(i = j, 0, j))
            i += 1
        End While
    End Function

    Function sieve(ByVal limit As Integer) As Boolean()
        Dim c As Boolean() = New Boolean(limit - 1) {}, i As Integer = 3
        While i * 3 < limit
            If Not c(i) AndAlso (chowla(i) = 0) Then
                Dim j As Integer = 3 * i
                While j < limit : c(j) = True : j += 2 * i : End While
            End If : i += 2
        End While
        Return c
    End Function

    Sub Main(args As String())
        For i As Integer = 1 To 37
            Console.WriteLine("chowla({0}) = {1}", i, chowla(i))
        Next
        Dim count As Integer = 1, limit As Integer = CInt((10000000.0)), power As Integer = 100,
            c As Boolean() = sieve(limit)
        For i As Integer = 3 To limit - 1 Step 2
            If Not c(i) Then count += 1
            If i = power - 1 Then
                Console.WriteLine("Count of primes up to {0,10:n0} = {1:n0}", power, count)
                power = power * 10
            End If
        Next
        count = 0 : limit = 35000000
        Dim p As Integer, k As Integer = 2, kk As Integer = 3
        While True
            p = k * kk : If p > limit Then Exit While
            If chowla(p) = p - 1 Then
                Console.WriteLine("{0,10:n0} is a number that is perfect", p)
                count += 1
            End If
            k = kk + 1 : kk += k
        End While
        Console.WriteLine("There are {0} perfect numbers <= 35,000,000", count)
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
