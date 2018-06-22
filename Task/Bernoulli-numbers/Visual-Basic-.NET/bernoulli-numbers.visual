' Bernoulli numbers - vb.net - 06/03/2017
Imports System.Numerics 'BigInteger

Module Bernoulli_numbers

    Function gcd_BigInt(ByVal x As BigInteger, ByVal y As BigInteger) As BigInteger
        Dim y2 As BigInteger
        x = BigInteger.Abs(x)
        Do
            y2 = BigInteger.Remainder(x, y)
            x = y
            y = y2
        Loop Until y = 0
        Return x
    End Function 'gcd_BigInt

    Sub bernoul_BigInt(n As Integer, ByRef bnum As BigInteger, ByRef bden As BigInteger)
        Dim j, m As Integer
        Dim f As BigInteger
        Dim anum(), aden() As BigInteger
        ReDim anum(n + 1), aden(n + 1)
        For m = 0 To n
            anum(m + 1) = 1
            aden(m + 1) = m + 1
            For j = m To 1 Step -1
                anum(j) = j * (aden(j + 1) * anum(j) - aden(j) * anum(j + 1))
                aden(j) = aden(j) * aden(j + 1)
                f = gcd_BigInt(BigInteger.Abs(anum(j)), BigInteger.Abs(aden(j)))
                If f <> 1 Then
                    anum(j) = anum(j) / f
                    aden(j) = aden(j) / f
                End If
            Next
        Next
        bnum = anum(1) : bden = aden(1)
    End Sub 'bernoul_BigInt

    Sub bernoulli_BigInt()
        Dim i As Integer
        Dim bnum, bden As BigInteger
        bnum = 0 : bden = 0
        For i = 0 To 60
            bernoul_BigInt(i, bnum, bden)
            If bnum <> 0 Then
                Console.WriteLine("B(" & i & ")=" & bnum.ToString("D") & "/" & bden.ToString("D"))
            End If
        Next i
    End Sub 'bernoulli_BigInt

End Module 'Bernoulli_numbers
