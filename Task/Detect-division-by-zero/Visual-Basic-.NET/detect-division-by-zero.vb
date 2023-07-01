Module DivByZeroDetection

    Sub Main()
        Console.WriteLine(safeDivision(10, 0))
    End Sub

    Private Function safeDivision(v1 As Integer, v2 As Integer) As Boolean
        Try
            Dim answer = v1 / v2
            Return False
        Catch ex As Exception
            Return True
        End Try
    End Function
End Module
