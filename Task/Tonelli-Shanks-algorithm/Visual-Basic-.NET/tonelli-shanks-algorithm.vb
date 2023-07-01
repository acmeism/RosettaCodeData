Imports System.Numerics

Module Module1

    Class Solution
        ReadOnly root1 As BigInteger
        ReadOnly root2 As BigInteger
        ReadOnly exists As Boolean

        Sub New(r1 As BigInteger, r2 As BigInteger, e As Boolean)
            root1 = r1
            root2 = r2
            exists = e
        End Sub

        Public Function GetRoot1() As BigInteger
            Return root1
        End Function

        Public Function GetRoot2() As BigInteger
            Return root2
        End Function

        Public Function GetExists() As Boolean
            Return exists
        End Function
    End Class

    Function Ts(n As BigInteger, p As BigInteger) As Solution
        If BigInteger.ModPow(n, (p - 1) / 2, p) <> 1 Then
            Return New Solution(0, 0, False)
        End If

        Dim q As BigInteger = p - 1
        Dim ss = BigInteger.Zero
        While (q Mod 2) = 0
            ss += 1
            q >>= 1
        End While

        If ss = 1 Then
            Dim r1 = BigInteger.ModPow(n, (p + 1) / 4, p)
            Return New Solution(r1, p - r1, True)
        End If

        Dim z As BigInteger = 2
        While BigInteger.ModPow(z, (p - 1) / 2, p) <> p - 1
            z += 1
        End While
        Dim c = BigInteger.ModPow(z, q, p)
        Dim r = BigInteger.ModPow(n, (q + 1) / 2, p)
        Dim t = BigInteger.ModPow(n, q, p)
        Dim m = ss

        Do
            If t = 1 Then
                Return New Solution(r, p - r, True)
            End If
            Dim i = BigInteger.Zero
            Dim zz = t
            While zz <> 1 AndAlso i < (m - 1)
                zz = zz * zz Mod p
                i += 1
            End While
            Dim b = c
            Dim e = m - i - 1
            While e > 0
                b = b * b Mod p
                e = e - 1
            End While
            r = r * b Mod p
            c = b * b Mod p
            t = t * c Mod p
            m = i
        Loop
    End Function

    Sub Main()
        Dim pairs = New List(Of Tuple(Of Long, Long)) From {
            New Tuple(Of Long, Long)(10, 13),
            New Tuple(Of Long, Long)(56, 101),
            New Tuple(Of Long, Long)(1030, 10009),
            New Tuple(Of Long, Long)(1032, 10009),
            New Tuple(Of Long, Long)(44402, 100049),
            New Tuple(Of Long, Long)(665820697, 1000000009),
            New Tuple(Of Long, Long)(881398088036, 1000000000039)
        }

        For Each pair In pairs
            Dim sol = Ts(pair.Item1, pair.Item2)
            Console.WriteLine("n = {0}", pair.Item1)
            Console.WriteLine("p = {0}", pair.Item2)
            If sol.GetExists() Then
                Console.WriteLine("root1 = {0}", sol.GetRoot1())
                Console.WriteLine("root2 = {0}", sol.GetRoot2())
            Else
                Console.WriteLine("No solution exists")
            End If
            Console.WriteLine()
        Next

        Dim bn = BigInteger.Parse("41660815127637347468140745042827704103445750172002")
        Dim bp = BigInteger.Pow(10, 50) + 577
        Dim bsol = Ts(bn, bp)
        Console.WriteLine("n = {0}", bn)
        Console.WriteLine("p = {0}", bp)
        If bsol.GetExists() Then
            Console.WriteLine("root1 = {0}", bsol.GetRoot1())
            Console.WriteLine("root2 = {0}", bsol.GetRoot2())
        Else
            Console.WriteLine("No solution exists")
        End If
    End Sub

End Module
