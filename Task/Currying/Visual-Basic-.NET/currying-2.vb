Module Main
    ' An example binary function.
    Function Add(a As Integer, b As Integer) As Integer
        Return a + b
    End Function

    Sub Main()
        Dim curriedAdd = Curry(Of Integer, Integer, Integer)(AddressOf Add)
        Dim add2To = curriedAdd(2)

        Console.WriteLine(Add(2, 3))
        Console.WriteLine(add2To(3))
        Console.WriteLine(curriedAdd(2)(3))

        ' An example ternary function.
        Dim substring = Function(s As String, startIndex As Integer, length As Integer) s.Substring(startIndex, length)
        Dim curriedSubstring = Curry(substring)

        Console.WriteLine(substring("abcdefg", 2, 3))
        Console.WriteLine(curriedSubstring("abcdefg")(2)(3))

        ' The above is just syntax sugar for this (a call to the Invoke() method of System.Delegate):
        Console.WriteLine(curriedSubstring.Invoke("abcdefg").Invoke(2).Invoke(3))

        Dim substringStartingAt1 = curriedSubstring("abcdefg")(1)
        Console.WriteLine(substringStartingAt1(2))
        Console.WriteLine(substringStartingAt1(4))
    End Sub
End Module
