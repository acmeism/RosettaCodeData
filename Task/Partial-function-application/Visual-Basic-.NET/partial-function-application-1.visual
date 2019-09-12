Module PartialApplication
    Function fs(Of TSource, TResult)(f As Func(Of TSource, TResult), s As IEnumerable(Of TSource)) As IEnumerable(Of TResult)
        ' This is exactly what Enumerable.Select does.
        Return s.Select(f)
    End Function

    Function f1(x As Integer) As Integer
        Return x * 2
    End Function

    Function f2(x As Integer) As Integer
        Return x * x
    End Function

    ' The overload that takes a binary function and partially applies to its first parameter.
    Function PartialApply(Of T1, T2, TResult)(f As Func(Of T1, T2, TResult), arg As T1) As Func(Of T2, TResult)
        Return Function(arg2) f(arg, arg2)
    End Function

    Sub Main()
        Dim args1 As Integer() = {0, 1, 2, 3}
        Dim args2 As Integer() = {2, 4, 6, 8}

        Dim fsf1 = PartialApply(Of Func(Of Integer, Integer), IEnumerable(Of Integer), IEnumerable(Of Integer))(AddressOf fs, AddressOf f1)
        Dim fsf2 = PartialApply(Of Func(Of Integer, Integer), IEnumerable(Of Integer), IEnumerable(Of Integer))(AddressOf fs, AddressOf f2)

        Console.WriteLine("fsf1, 0-3: " & String.Join(", ", fsf1(args1)))
        Console.WriteLine("fsf1, evens: " & String.Join(", ", fsf1(args2)))
        Console.WriteLine("fsf2, 0-3: " & String.Join(", ", fsf2(args1)))
        Console.WriteLine("fsf2, evens: " & String.Join(", ", fsf2(args2)))
    End Sub
End Module
