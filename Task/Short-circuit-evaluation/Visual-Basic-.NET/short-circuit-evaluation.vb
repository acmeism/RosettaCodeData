Module Module1

    Function A(v As Boolean) As Boolean
        Console.WriteLine("a")
        Return v
    End Function

    Function B(v As Boolean) As Boolean
        Console.WriteLine("b")
        Return v
    End Function

    Sub Test(i As Boolean, j As Boolean)
        Console.WriteLine("{0} and {1} = {2} (eager evaluation)", i, j, A(i) And B(j))
        Console.WriteLine("{0} or {1} = {2} (eager evaluation)", i, j, A(i) Or B(j))
        Console.WriteLine("{0} and {1} = {2} (lazy evaluation)", i, j, A(i) AndAlso B(j))
        Console.WriteLine("{0} or {1} = {2} (lazy evaluation)", i, j, A(i) OrElse B(j))

        Console.WriteLine()
    End Sub

    Sub Main()
        Test(False, False)
        Test(False, True)
        Test(True, False)
        Test(True, True)
    End Sub

End Module
