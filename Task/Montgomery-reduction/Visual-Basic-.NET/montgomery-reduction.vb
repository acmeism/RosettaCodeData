Imports System.Numerics
Imports System.Runtime.CompilerServices

Module Module1

    <Extension()>
    Function BitLength(v As BigInteger) As Integer
        If v < 0 Then
            v *= -1
        End If

        Dim result = 0
        While v > 0
            v >>= 1
            result += 1
        End While
        Return result
    End Function

    Structure Montgomery
        Shared ReadOnly BASE = 2
        Dim m As BigInteger
        Dim rrm As BigInteger
        Dim n As Integer

        Sub New(m As BigInteger)
            If m < 0 OrElse m.IsEven Then
                Throw New ArgumentException()
            End If

            Me.m = m
            n = m.BitLength
            rrm = (BigInteger.One << (n * 2)) Mod m
        End Sub

        Function Reduce(t As BigInteger) As BigInteger
            Dim a = t
            For i = 1 To n
                If Not a.IsEven Then
                    a += m
                End If
                a >>= 1
            Next
            If a >= m Then
                a -= m
            End If
            Return a
        End Function
    End Structure

    Sub Main()
        Dim m = BigInteger.Parse("750791094644726559640638407699")
        Dim x1 = BigInteger.Parse("540019781128412936473322405310")
        Dim x2 = BigInteger.Parse("515692107665463680305819378593")

        Dim mont As New Montgomery(m)
        Dim t1 = x1 * mont.rrm
        Dim t2 = x2 * mont.rrm

        Dim r1 = mont.Reduce(t1)
        Dim r2 = mont.Reduce(t2)
        Dim r = BigInteger.One << mont.n

        Console.WriteLine("b :  {0}", Montgomery.BASE)
        Console.WriteLine("n :  {0}", mont.n)
        Console.WriteLine("r :  {0}", r)
        Console.WriteLine("m :  {0}", mont.m)
        Console.WriteLine("t1:  {0}", t1)
        Console.WriteLine("t2:  {0}", t2)
        Console.WriteLine("r1:  {0}", r1)
        Console.WriteLine("r2:  {0}", r2)
        Console.WriteLine()
        Console.WriteLine("Original x1       : {0}", x1)
        Console.WriteLine("Recovered from r1 : {0}", mont.Reduce(r1))
        Console.WriteLine("Original x2       : {0}", x2)
        Console.WriteLine("Recovered from r2 : {0}", mont.Reduce(r2))

        Console.WriteLine()
        Console.WriteLine("Montgomery computation of x1 ^ x2 mod m :")
        Dim prod = mont.Reduce(mont.rrm)
        Dim base = mont.Reduce(x1 * mont.rrm)
        Dim exp = x2
        While exp.BitLength > 0
            If Not exp.IsEven Then
                prod = mont.Reduce(prod * base)
            End If
            exp >>= 1
            base = mont.Reduce(base * base)
        End While
        Console.WriteLine(mont.Reduce(prod))
        Console.WriteLine()
        Console.WriteLine("Alternate computation of x1 ^ x2 mod m :")
        Console.WriteLine(BigInteger.ModPow(x1, x2, m))
    End Sub

End Module
