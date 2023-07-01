Class U0
    Inherits Exception
End Class

Class U1
    Inherits Exception
End Class

Module Program
    Sub Main()
        Foo()
    End Sub

    Sub Foo()
        Try
            Bar()
            Bar()
        Catch ex As U0
            Console.WriteLine(ex.GetType.Name & " caught.")
        End Try
    End Sub

    Sub Bar()
        Baz()
    End Sub

    Sub Baz()
        ' Static local variable is persisted between calls of the method and is initialized only once.
        Static firstCall As Boolean = True
        If firstCall Then
            firstCall = False
            Throw New U0()
        Else
            Throw New U1()
        End If
    End Sub
End Module
