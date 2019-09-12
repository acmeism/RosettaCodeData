Module Module1

    Function DotProduct(a As Decimal(), b As Decimal()) As Decimal
        Return a.Zip(b, Function(x, y) x * y).Sum()
    End Function

    Sub Main()
        Console.WriteLine(DotProduct({1, 3, -5}, {4, -2, -1}))
        Console.ReadLine()
    End Sub

End Module
