Imports System.Numerics

Module Module1

    ReadOnly BIG = BigInteger.Pow(10, 50) + 151

    Function C(ns As String, ps As String) As Tuple(Of BigInteger, BigInteger, Boolean)
        Dim n = BigInteger.Parse(ns)
        Dim p = If(ps.Length > 0, BigInteger.Parse(ps), BIG)

        ' Legendre symbol. Returns 1, 0, or p-1
        Dim ls = Function(a0 As BigInteger) BigInteger.ModPow(a0, (p - 1) / 2, p)

        ' Step 0: validate arguments
        If ls(n) <> 1 Then
            Return Tuple.Create(BigInteger.Zero, BigInteger.Zero, False)
        End If

        ' Step 1: Find a, omega2
        Dim a = BigInteger.Zero
        Dim omega2 As BigInteger
        Do
            omega2 = (a * a + p - n) Mod p
            If ls(omega2) = p - 1 Then
                Exit Do
            End If
            a += 1
        Loop

        ' Multiplication in Fp2
        Dim mul = Function(aa As Tuple(Of BigInteger, BigInteger), bb As Tuple(Of BigInteger, BigInteger))
                      Return Tuple.Create((aa.Item1 * bb.Item1 + aa.Item2 * bb.Item2 * omega2) Mod p, (aa.Item1 * bb.Item2 + bb.Item1 * aa.Item2) Mod p)
                  End Function

        ' Step 2: Compute power
        Dim r = Tuple.Create(BigInteger.One, BigInteger.Zero)
        Dim s = Tuple.Create(a, BigInteger.One)
        Dim nn = ((p + 1) >> 1) Mod p
        While nn > 0
            If nn Mod 2 = 1 Then
                r = mul(r, s)
            End If
            s = mul(s, s)
            nn >>= 1
        End While

        ' Step 3: Check x in Fp
        If r.Item2 <> 0 Then
            Return Tuple.Create(BigInteger.Zero, BigInteger.Zero, False)
        End If

        ' Step 5: Check x * x = n
        If r.Item1 * r.Item1 Mod p <> n Then
            Return Tuple.Create(BigInteger.Zero, BigInteger.Zero, False)
        End If

        ' Step 4: Solutions
        Return Tuple.Create(r.Item1, p - r.Item1, True)
    End Function

    Sub Main()
        Console.WriteLine(C("10", "13"))
        Console.WriteLine(C("56", "101"))
        Console.WriteLine(C("8218", "10007"))
        Console.WriteLine(C("8219", "10007"))
        Console.WriteLine(C("331575", "1000003"))
        Console.WriteLine(C("665165880", "1000000007"))
        Console.WriteLine(C("881398088036", "1000000000039"))
        Console.WriteLine(C("34035243914635549601583369544560650254325084643201", ""))
    End Sub

End Module
