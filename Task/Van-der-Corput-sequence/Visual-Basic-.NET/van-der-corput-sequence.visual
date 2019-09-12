Module Module1

    Function ToBase(n As Integer, b As Integer) As String
        Dim result = ""
        If b < 2 Or b > 16 Then
            Throw New ArgumentException("The base is out of range")
        End If

        Do
            Dim remainder = n Mod b
            result = "0123456789ABCDEF"(remainder) + result
            n = n \ b
        Loop While n > 0

        Return result
    End Function

    Sub Main()
        For b = 2 To 5
            Console.WriteLine("Base = {0}", b)
            For i = 0 To 12
                Dim s = "." + ToBase(i, b)
                Console.Write("{0,6} ", s)
            Next
            Console.WriteLine()
            Console.WriteLine()
        Next
    End Sub

End Module
