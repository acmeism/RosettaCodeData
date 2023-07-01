Imports System.Runtime.CompilerServices

Module Module1

    <Extension()>
    Function Gmean(n As IEnumerable(Of Double)) As Double
        Return Math.Pow(n.Aggregate(Function(s, i) s * i), 1.0 / n.Count())
    End Function

    <Extension()>
    Function Hmean(n As IEnumerable(Of Double)) As Double
        Return n.Count() / n.Sum(Function(i) 1.0 / i)
    End Function

    Sub Main()
        Dim nums = From n In Enumerable.Range(1, 10) Select CDbl(n)

        Dim a = nums.Average()
        Dim g = nums.Gmean()
        Dim h = nums.Hmean()

        Console.WriteLine("Arithmetic mean {0}", a)
        Console.WriteLine(" Geometric mean {0}", g)
        Console.WriteLine("  Harmonic mean {0}", h)
        Debug.Assert(a >= g AndAlso g >= h)
    End Sub

End Module
