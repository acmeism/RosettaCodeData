Option Strict On

Partial Module PartialApplicationDynamic
    ' Create a matching delegate type to simplify delegate creation.
    Delegate Function fsDelegate(Of TSource, TResult)(f As Func(Of TSource, TResult), s As IEnumerable(Of TSource)) As IEnumerable(Of TResult)
    Function fs(Of TSource, TResult)(f As Func(Of TSource, TResult), s As IEnumerable(Of TSource)) As IEnumerable(Of TResult)
        ' This is exactly what Enumerable.Select does.
        Return s.Select(f)
    End Function

    Function ArrayConcat(Of T)(arr1 As T(), arr2 As T()) As T()
        Dim result(arr1.Length + arr2.Length - 1) As T
        Array.Copy(arr1, result, arr1.Length)
        Array.Copy(arr2, 0, result, 1, arr2.Length)
        Return result
    End Function

    ' C# can define ParamArray delegates and VB can consume them, but VB cannot define them on its own.
    ' The argument list of calls to the resulting function thus must be wrapped in a coerced array literal.
    ' VB also doesn't allow Delegate as a type constraint. :(
    ' The function is generic solely to ease use for callers. In this case generics aren't providing any type-safety.
    Function PartialApplyDynamic(Of TDelegate, TResult)(f As TDelegate, ParamArray args As Object()) As Func(Of Object(), TResult)
        Dim del = CType(CObj(f), [Delegate])
        Return Function(rest) CType(del.DynamicInvoke(ArrayConcat(args, rest).Cast(Of Object).ToArray()), TResult)
    End Function

    Sub Main()
        Dim args1 As Object = New Object() {0, 1, 2, 3}
        Dim args2 As Object = New Object() {2, 4, 6, 8}

        Dim fsf1 = PartialApplyDynamic(Of fsDelegate(Of Object, Object), IEnumerable(Of Object))(AddressOf fs, New Func(Of Object, Object)(AddressOf f1))
        Dim fsf2 = PartialApplyDynamic(Of fsDelegate(Of Object, Object), IEnumerable(Of Object))(AddressOf fs, New Func(Of Object, Object)(AddressOf f2))

        ' The braces are array literals.
        Console.WriteLine("fsf1, 0-3: " & String.Join(", ", fsf1({args1})))
        Console.WriteLine("fsf1, evens: " & String.Join(", ", fsf1({args2})))
        Console.WriteLine("fsf2, 0-3: " & String.Join(", ", fsf2({args1})))
        Console.WriteLine("fsf2, evens: " & String.Join(", ", fsf2({args2})))
    End Sub
End Module
