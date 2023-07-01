Imports System.Numerics

Module Program
    Function chowla(n As Integer) As Integer
        chowla = 0 : Dim j As Integer, i As Integer = 2
        While i * i <= n
            If n Mod i = 0 Then j = n / i : chowla += i : If i <> j Then chowla += j
            i += 1
        End While
    End Function

    Function chowla1(ByRef n As BigInteger, x As Integer) As BigInteger
        chowla1 = 1 : Dim j As BigInteger, lim As BigInteger = BigInteger.Pow(2, x - 1)
        For i As BigInteger = 2 To lim
            If n Mod i = 0 Then j = n / i : chowla1 += i : If i <> j Then chowla1 += j
        Next
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
        count = 0
        Dim p As BigInteger, k As BigInteger = 2, kk As BigInteger = 3
        For i As Integer = 2 To 31 ' if you dare, change the 31 to 61 or 89
            If {2, 3, 5, 7, 13, 17, 19, 31, 61, 89}.Contains(i) Then
                p = k * kk
                If chowla1(p, i) = p Then
                    Console.WriteLine("{0,25:n0} is a number that is perfect", p)
                    st = DateTime.Now
                    count += 1
                End If
            End If
            k = kk + 1 : kk += k
        Next
        Console.WriteLine("There are {0} perfect numbers <= {1:n0}", count, 25 * BigInteger.Pow(10, 18))
        If System.Diagnostics.Debugger.IsAttached Then Console.ReadKey()
    End Sub
End Module
