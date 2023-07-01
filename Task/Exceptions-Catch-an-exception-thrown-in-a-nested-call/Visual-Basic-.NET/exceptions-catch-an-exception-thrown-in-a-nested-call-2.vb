    Sub Foo()
        For i = 1 To 2
            Try
                Bar()
            Catch ex As U0
                Console.WriteLine(ex.GetType().Name & " caught.")
            End Try
        Next
    End Sub
