Imports System.Math

Module Module1

    Function MeanAngle(angles As Double()) As Double
        Dim x = angles.Sum(Function(a) Cos(a * PI / 180)) / angles.Length
        Dim y = angles.Sum(Function(a) Sin(a * PI / 180)) / angles.Length
        Return Atan2(y, x) * 180 / PI
    End Function

    Sub Main()
        Dim printMean = Sub(x As Double()) Console.WriteLine("{0:0.###}", MeanAngle(x))
        printMean({350, 10})
        printMean({90, 180, 270, 360})
        printMean({10, 20, 30})
    End Sub

End Module
