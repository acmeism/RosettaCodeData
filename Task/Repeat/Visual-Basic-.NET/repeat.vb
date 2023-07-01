Module Module1

    Sub Repeat(count As Integer, fn As Action(Of Integer))
        If IsNothing(fn) Then
            Throw New ArgumentNullException("fn")
        End If

        For i = 1 To count
            fn.Invoke(i)
        Next
    End Sub

    Sub Main()
        Repeat(3, Sub(x) Console.WriteLine("Example {0}", x))
    End Sub

End Module
