Imports System
Imports System.Console
Imports BI = System.Numerics.BigInteger

Module Module1
    Function isqrt(ByVal x As BI) As BI
        Dim t As BI, q As BI = 1, r As BI = 0
        While q <= x : q <<= 2 : End While
        While q > 1 : q >>= 2 : t = x - r - q : r >>= 1
            If t >= 0 Then x = t : r += q
        End While : Return r
    End Function

    Sub Main()
        Const max As Integer = 73, smax As Integer = 65
        Dim power_width As Integer = ((BI.Pow(7, max).ToString().Length \ 3) << 2) + 3,
            isqrt_width As Integer = (power_width + 1) >> 1,
            n as Integer
        WriteLine("Integer square root for numbers 0 to {0}:", smax)
        For n = 0 To smax : Write("{0} ", (n \ 10).ToString().Replace("0", " "))
            Next : WriteLine()
        For n = 0 To smax : Write("{0} ", n Mod 10) : Next : WriteLine()
        WriteLine(New String("-"c, (smax << 1) + 1))
        For n = 0 To smax : Write("{0} ", isqrt(n)) : Next
        WriteLine(vbLf & vbLf & "Integer square roots of odd powers of 7 from 1 to {0}:", max)
        Dim s As String = String.Format("[0,2] |[1,{0}:n0] |[2,{1}:n0]",
            power_width, isqrt_width).Replace("[", "{").Replace("]", "}")
        WriteLine(s, "n", "7 ^ n", "isqrt(7 ^ n)")
        WriteLine(New String("-"c, power_width + isqrt_width + 6))
        Dim p As BI = 7 : n = 1 : While n <= max
            WriteLine(s, n, p, isqrt(p)) : n += 2 : p = p * 49
        End While
    End Sub
End Module
