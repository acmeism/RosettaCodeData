Imports System.Runtime.CompilerServices

Module Module1

    <Extension()>
    Function ApproxEquals(ByVal value As Double, other As Double, epsilon As Double)
        Return Math.Abs(value - other) < epsilon
    End Function

    Sub Test(a As Double, b As Double)
        Dim epsilon = 1.0E-18
        Console.WriteLine($"{a}, {b} => {a.ApproxEquals(b, epsilon)}")
    End Sub

    Sub Main()
        Test(100000000000000.02, 100000000000000.02)
        Test(100.01, 100.011)
        Test(10000000000000.002 / 10000.0, 1000000000.0000001)
        Test(0.001, 0.0010000001)
        Test(1.01E-22, 0.0)
        Test(Math.Sqrt(2) * Math.Sqrt(2), 2.0)
        Test(-Math.Sqrt(2) * Math.Sqrt(2), -2.0)
        Test(3.1415926535897931, 3.1415926535897931)
    End Sub

End Module
