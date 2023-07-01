Imports System, BI = System.Numerics.BigInteger, System.Console

Module Module1

    Function isqrt(ByVal x As BI) As BI
        Dim t As BI, q As BI = 1, r As BI = 0
        While q <= x : q <<= 2 : End While
        While q > 1 : q >>= 2 : t = x - r - q : r >>= 1
            If t >= 0 Then x = t : r += q
        End While : Return r
    End Function

    Function dump(ByVal digs As Integer, ByVal Optional show As Boolean = False) As String
        digs += 1
        Dim z As Integer, gb As Integer = 1, dg As Integer = digs + gb
        Dim te As BI, t1 As BI = 1, t2 As BI = 9, t3 As BI = 1, su As BI = 0, t As BI = BI.Pow(10, If(dg <= 60, 0, dg - 60)), d As BI = -1, fn As BI = 1
        For n As BI = 0 To dg - 1
            If n > 0 Then t3 = t3 * BI.Pow(n, 6)
            te = t1 * t2 / t3 : z = dg - 1 - CInt(n) * 6
            If z > 0 Then te = te * BI.Pow(10, z) Else te = te / BI.Pow(10, -z)
            If show AndAlso n < 10 Then WriteLine("{0,2} {1,62}", n, te * 32 / 3 / t)
            su += te : If te < 10 Then
                digs -= 1
                If show Then WriteLine(vbLf & "{0} iterations required for {1} digits " & _
                    "after the decimal point." & vbLf, n, digs)
                Exit For
            End If
            For j As BI = n * 6 + 1 To n * 6 + 6
                t1 = t1 * j : Next
            d += 2 : t2 += 126 + 532 * d
        Next
        Dim s As String = String.Format("{0}", isqrt(BI.Pow(10, dg * 2 + 3) _
            / su / 32 * 3 * BI.Pow(CType(10, BI), dg + 5)))
        Return s(0) & "." & s.Substring(1, digs)
    End Function

    Sub Main(ByVal args As String())
        WriteLine(dump(70, true))
    End Sub

End Module
