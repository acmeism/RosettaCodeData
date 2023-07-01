Imports System.Numerics
Imports System.Runtime.CompilerServices
Imports System.Threading

Module Module1
    Private s_gen As New ThreadLocal(Of Random)(Function() New Random())

    Private Function Gen()
        Return s_gen.Value
    End Function

    <Extension()>
    Public Function IsProbablyPrime(value As BigInteger, Optional witnesses As Integer = 10) As Boolean
        If value <= 1 Then
            Return False
        End If

        If witnesses <= 0 Then
            witnesses = 10
        End If

        Dim d = value - 1
        Dim s = 0

        While d Mod 2 = 0
            d /= 2
            s += 1
        End While

        Dim bytes(value.ToByteArray.LongLength - 1) As Byte
        Dim a As BigInteger

        For i = 1 To witnesses
            Do
                Gen.NextBytes(bytes)

                a = New BigInteger(bytes)
            Loop While a < 2 OrElse a >= value - 2

            Dim x = BigInteger.ModPow(a, d, value)
            If x = 1 OrElse x = value - 1 Then
                Continue For
            End If

            For r = 1 To s - 1
                x = BigInteger.ModPow(x, 2, value)

                If x = 1 Then
                    Return False
                End If
                If x = value - 1 Then
                    Exit For
                End If
            Next

            If x <> value - 1 Then
                Return False
            End If
        Next

        Return True
    End Function

    <Extension()>
    Function Sqrt(self As BigInteger) As BigInteger
        Dim b = self
        While True
            Dim a = b
            b = self / a + a >> 1
            If b >= a Then
                Return a
            End If
        End While
        Throw New Exception("Should not have happened")
    End Function

    <Extension()>
    Function BitLength(self As BigInteger) As Long
        Dim bi = self
        Dim len = 0L
        While bi <> 0
            len += 1
            bi >>= 1
        End While
        Return len
    End Function

    <Extension()>
    Function BitTest(self As BigInteger, pos As Integer) As Boolean
        Dim arr = self.ToByteArray
        Dim i = pos \ 8
        Dim m = pos Mod 8
        If i >= arr.Length Then
            Return False
        End If
        Return (arr(i) And (1 << m)) > 0
    End Function

    Class PExp
        Sub New(p As BigInteger, e As Integer)
            Prime = p
            Exp = e
        End Sub

        Public ReadOnly Property Prime As BigInteger
        Public ReadOnly Property Exp As Integer
    End Class

    Function MoBachShallit58(a As BigInteger, n As BigInteger, pf As List(Of PExp)) As BigInteger
        Dim n1 = n - 1
        Dim mo As BigInteger = 1
        For Each pe In pf
            Dim y = n1 / BigInteger.Pow(pe.Prime, pe.Exp)
            Dim o = 0
            Dim x = BigInteger.ModPow(a, y, BigInteger.Abs(n))
            While x > 1
                x = BigInteger.ModPow(x, pe.Prime, BigInteger.Abs(n))
                o += 1
            End While
            Dim o1 = BigInteger.Pow(pe.Prime, o)
            o1 /= BigInteger.GreatestCommonDivisor(mo, o1)
            mo *= o1
        Next
        Return mo
    End Function

    Function Factor(n As BigInteger) As List(Of PExp)
        Dim pf As New List(Of PExp)
        Dim nn = n
        Dim e = 0
        While Not nn.BitTest(e)
            e += 1
        End While
        If e > 0 Then
            nn >>= e
            pf.Add(New PExp(2, e))
        End If
        Dim s = nn.Sqrt
        Dim d As BigInteger = 3
        While nn > 1
            If d > s Then
                d = nn
            End If
            e = 0
            While True
                Dim remainder As New BigInteger
                Dim div = BigInteger.DivRem(nn, d, remainder)
                If remainder.BitLength > 0 Then
                    Exit While
                End If
                nn = div
                e += 1
            End While
            If e > 0 Then
                pf.Add(New PExp(d, e))
                s = nn.Sqrt
            End If
            d += 2
        End While
        Return pf
    End Function

    Sub MoTest(a As BigInteger, n As BigInteger)
        If Not n.IsProbablyPrime(20) Then
            Console.WriteLine("Not computed. Modulus must be prime for this algorithm.")
            Return
        End If
        If a.BitLength < 100 Then
            Console.Write("ord({0})", a)
        Else
            Console.Write("ord([big])")
        End If
        If n.BitLength < 100 Then
            Console.Write(" mod {0}", n)
        Else
            Console.Write(" mod [big]")
        End If
        Dim mob = MoBachShallit58(a, n, Factor(n - 1))
        Console.WriteLine(" = {0}", mob)
    End Sub

    Sub Main()
        MoTest(37, 3343)
        MoTest(BigInteger.Pow(10, 100) + 1, 7919)
        MoTest(BigInteger.Pow(10, 1000) + 1, 15485863)
        MoTest(BigInteger.Pow(10, 10000) - 1, 22801763489)
        MoTest(1511678068, 7379191741)
        MoTest(3047753288, 2257683301)
    End Sub

End Module
