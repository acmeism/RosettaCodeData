Module Program
    Function Add(a As Integer, b As Integer) As Integer
        Return a + b
    End Function

    Sub Main()
        ' A delegate for the function must be created in order to eagerly perform overload resolution.
        Dim curriedAdd = DynamicCurry(New Func(Of Integer, Integer, Integer)(AddressOf Add))
        Dim add2To = curriedAdd(2)

        Console.WriteLine(add2To(3).Unwrap(Of Integer))
        Console.WriteLine(curriedAdd(2)(3).Unwrap(Of Integer))

        Dim substring = Function(s As String, i1 As Integer, i2 As Integer) s.Substring(i1, i2)
        Dim curriedSubstring = DynamicCurry(substring)

        Console.WriteLine(substring("abcdefg", 2, 3))
        Console.WriteLine(curriedSubstring("abcdefg")(2)(3).Unwrap(Of String))

        ' The trickery of using a parameterized default property also makes it appear that the "delegate" has an Invoke() method.
        Console.WriteLine(curriedSubstring.Invoke("abcdefg").Invoke(2).Invoke(3).Unwrap(Of String))

        Dim substringStartingAt1 = curriedSubstring("abcdefg")(1)
        Console.WriteLine(substringStartingAt1(2).Unwrap(Of String))
        Console.WriteLine(substringStartingAt1(4).Unwrap(Of String))
    End Sub
End Module
