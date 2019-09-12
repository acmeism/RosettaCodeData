Module Program
    ' Uses the System generic delegate; see C# entry for details.
    Function [Call](f As Func(Of Integer, Integer, Integer), a As Integer, b As Integer) As Integer
        Return f(a, b)
    End Function

    Sub Main()
        Dim a = 6
        Dim b = 2

        Console.WriteLine("f=Add, f({0}, {1}) = {2}", a, b, [Call](Function(x As Integer, y As Integer) x + y, a, b))

                                                                   ' With inferred parameter types:
        Console.WriteLine("f=Mul, f({0}, {1}) = {2}", a, b, [Call](Function(x, y) x * y, a, b))

        ' The block syntax must be used in order to specify a return type. As there is no target type in this case, the parameter types must be explicitly specified. anon has an anonymous, compiler-generated type.
        Dim anon = Function(x As Integer, y As Integer) As Integer
                       Return x \ y
                   End Function

        ' Parameters are contravariant and the return type is covariant. Note that this conversion is not valid CLR variance (which disallows boxing conversions) and so is compiled as an additional anonymous delegate that explicitly boxes the return value.
        Dim example As Func(Of Integer, Integer, Object) = anon

        ' Dropped-return-type conversion.
        Dim example2 As Action(Of Integer, Integer) = anon

        Console.WriteLine("f=Div, f({0}, {1}) = {2}", a, b, [Call](anon, a, b))
    End Sub
End Module
