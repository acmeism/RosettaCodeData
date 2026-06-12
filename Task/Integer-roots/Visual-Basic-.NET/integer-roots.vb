Imports System
Imports System.Numerics
Imports Microsoft.VisualBasic.Strings

Public Module Module1

    Public Function IntSqRoot(v As BigInteger) As BigInteger
        Dim digs As Integer = Math.Max(0, v.ToString().Length / 2 - 1)
        IntSqRoot = BigInteger.Parse("3" & StrDup(digs, "0"))
        Dim term As BigInteger
        Do
            term = v / IntSqRoot
            If Math.Abs(CDbl(term - IntSqRoot)) < 2 Then Exit Do
            IntSqRoot = (IntSqRoot + term) / 2
        Loop Until False
    End Function

    Public Function IntNthRoot(n As Integer, v As BigInteger) As BigInteger
        Dim digs As Integer = Math.Max(0, v.ToString().Length / n - 1)
        IntNthRoot = BigInteger.Parse(If(digs > 1, 3, 2).ToString() & StrDup(digs, "0"))
        Dim va As BigInteger, dr As BigInteger
        Do
            va = v : For i As Integer = 2 To n : va /= IntNthRoot : Next
            va -= IntNthRoot
            dr = va / n : If dr = 0 Then Exit Do
            IntNthRoot += dr
        Loop Until False
    End Function

    Public Sub Main()
        Dim b As BigInteger = BigInteger.Parse("2" & StrDup(4008, "0"))
        Console.WriteLine("Integer Cube Root of 8:")
        Console.WriteLine(IntNthRoot(3, 8).ToString()) ' given example
        Console.WriteLine("Integer Cube Root of 9:")
        Console.WriteLine(IntNthRoot(3, 9).ToString()) ' given example
        Console.WriteLine("Integer Square Root of 2, (actually 2 * 10 ^ 4008, square root method):")
        Console.WriteLine(IntSqRoot(b).ToString()) ' reality check
        Console.WriteLine("Integer Square Root of 2, (actually 2 * 10 ^ 4008, nth root method):")
        Console.WriteLine(IntNthRoot(2, b).ToString()) ' given example
        Console.WriteLine("Integer Cube Root of 2, (actually 2 * 10 ^ 4008):")
        Console.WriteLine(IntNthRoot(3, b).ToString()) ' bonus example
        b /= 10000
        Console.WriteLine("Integer 7th Root of 2, (actually 2 * 10 ^ 4004):")
        Console.WriteLine(IntNthRoot(7, b).ToString()) ' bonus example
        If Diagnostics.Debugger.IsAttached Then Console.Read()
    End Sub

End Module
