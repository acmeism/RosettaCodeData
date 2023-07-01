Module Module1

    Class Vector
        Public store As Double()

        Public Sub New(init As IEnumerable(Of Double))
            store = init.ToArray()
        End Sub

        Public Sub New(x As Double, y As Double)
            store = {x, y}
        End Sub

        Public Overloads Shared Operator +(v1 As Vector, v2 As Vector)
            Return New Vector(v1.store.Zip(v2.store, Function(a, b) a + b))
        End Operator

        Public Overloads Shared Operator -(v1 As Vector, v2 As Vector)
            Return New Vector(v1.store.Zip(v2.store, Function(a, b) a - b))
        End Operator

        Public Overloads Shared Operator *(v1 As Vector, scalar As Double)
            Return New Vector(v1.store.Select(Function(x) x * scalar))
        End Operator

        Public Overloads Shared Operator /(v1 As Vector, scalar As Double)
            Return New Vector(v1.store.Select(Function(x) x / scalar))
        End Operator

        Public Overrides Function ToString() As String
            Return String.Format("[{0}]", String.Join(",", store))
        End Function
    End Class

    Sub Main()
        Dim v1 As New Vector(5, 7)
        Dim v2 As New Vector(2, 3)
        Console.WriteLine(v1 + v2)
        Console.WriteLine(v1 - v2)
        Console.WriteLine(v1 * 11)
        Console.WriteLine(v1 / 2)
        ' Works with arbitrary size vectors, too.
        Dim lostVector As New Vector({4, 8, 15, 16, 23, 42})
        Console.WriteLine(lostVector * 7)
    End Sub

End Module
