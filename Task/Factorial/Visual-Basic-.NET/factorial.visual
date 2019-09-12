Imports System
Imports System.Numerics
Imports System.Linq

Module Module1

    ' Type Double:

    Function DofactorialI(n As Integer) As Double ' Iterative
        DofactorialI = 1 : For i As Integer = 1 To n : DofactorialI *= i : Next
    End Function

    ' Type Unsigned Long:

    Function ULfactorialI(n As Integer) As ULong ' Iterative
        ULfactorialI = 1 : For i As Integer = 1 To n : ULfactorialI *= i : Next
    End Function

    ' Type Decimal:

    Function DefactorialI(n As Integer) As Decimal ' Iterative
        DefactorialI = 1 : For i As Integer = 1 To n : DefactorialI *= i : Next
    End Function

    ' Extends precision by "dehydrating" and "rehydrating" the powers of ten
    Function DxfactorialI(n As Integer) As String ' Iterative
        Dim factorial as Decimal = 1, zeros as integer = 0
        For i As Integer = 1 To n : factorial *= i
            If factorial Mod 10 = 0 Then factorial /= 10 : zeros += 1
        Next : Return factorial.ToString() & New String("0", zeros)
    End Function

    ' Arbitrary Precision:

    Function FactorialI(n As Integer) As BigInteger ' Iterative
        factorialI = 1 : For i As Integer = 1 To n : factorialI *= i : Next
    End Function

    Function Factorial(number As Integer) As BigInteger ' Functional
        Return Enumerable.Range(1, number).Aggregate(New BigInteger(1),
            Function(acc, num) acc * num)
    End Function

    Sub Main()
        Console.WriteLine("Double  : {0}! = {1:0}", 20, DoFactorialI(20))
        Console.WriteLine("ULong   : {0}! = {1:0}", 20, ULFactorialI(20))
        Console.WriteLine("Decimal : {0}! = {1:0}", 27, DeFactorialI(27))
        Console.WriteLine("Dec.Ext : {0}! = {1:0}", 32, DxFactorialI(32))
        Console.WriteLine("Arb.Prec: {0}! = {1}", 250, Factorial(250))
    End Sub
End Module
