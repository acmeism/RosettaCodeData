Imports System, System.Numerics, System.Math, System.Console

Module Program
    Function CalcE(ByVal nDigs As Integer) As String
        Dim pad As Integer = Round(Log10(nDigs)), n = 1,
            f As BigInteger = BigInteger.Pow(10, nDigs + pad), e = f + f
        Do : n+= 1 : f /= n : e += f : Loop While f > n
        Return (e / BigInteger.Pow(10, pad + 1)).ToString().Insert(1, ".")
    End Function

    Sub Main()
        WriteLine(Exp(1))  '  double precision built-in function
        WriteLine(CalcE(100))   '  arbitrary precision result
        Dim st As DateTime = DateTime.Now, qmil As Integer = 250_000,
            es As String = CalcE(qmil)  '  large arbitrary precision result string
        WriteLine("{0:n0} digits in {1:n3} seconds.", qmil, (DateTime.Now - st).TotalSeconds)
        WriteLine("partial: {0}...{1}", es.Substring(0, 46), es.Substring(es.Length - 45))
    End Sub
End Module
