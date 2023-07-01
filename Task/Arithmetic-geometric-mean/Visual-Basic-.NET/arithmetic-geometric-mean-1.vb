Imports System.Math
Imports System.Console

Module Module1

    Function CalcAGM(ByVal a As Double, ByVal b As Double) As Double
        Dim c As Double, d As Double = 0, ld As Double = 1
        While ld <> d : c = a : a = (a + b) / 2 : b = Sqrt(c * b)
            ld = d : d = a - b : End While : Return b
    End Function

    Function DecSqRoot(ByVal v As Decimal) As Decimal
        Dim r As Decimal = CDec(Sqrt(CDbl(v))), t As Decimal = 0, d As Decimal = 0, ld As Decimal = 1
        While ld <> d : t = v / r : r = (r + t) / 2
            ld = d : d = t - r : End While : Return t
    End Function

    Function CalcAGM(ByVal a As Decimal, ByVal b As Decimal) As Decimal
        Dim c As Decimal, d As Decimal = 0, ld As Decimal = 1
        While ld <> d : c = a : a = (a + b) / 2 : b = DecSqRoot(c * b)
            ld = d : d = a - b : End While : Return b
    End Function

    Sub Main(ByVal args As String())
        WriteLine("Double  result: {0}", CalcAGM(1.0, DecSqRoot(0.5)))
        WriteLine("Decimal result: {0}", CalcAGM(1D, DecSqRoot(0.5D)))
        If System.Diagnostics.Debugger.IsAttached Then ReadKey()
    End Sub

End Module
