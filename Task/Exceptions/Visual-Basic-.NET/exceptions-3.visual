Sub bar()
    Try
        foo()
    Catch e As MyException When e.Data.Contains("Foo")
        ' handle exceptions of type MyException when the exception contains specific data
    Catch e As MyException
        ' handle exceptions of type MyException and derived exceptions
    Catch e As Exception
        ' handle any type of exception not handled by above catches
    Finally
        'code here occurs whether or not there was an exception
    End Try
End Sub
