Imports System.Text

Module Module1

    Function RemoveVowels(s As String) As String
        Dim sb As New StringBuilder
        For Each c In s
            Select Case c
                Case "A", "a"
                Case "E", "e"
                Case "I", "i"
                Case "O", "o"
                Case "U", "u"
                    Exit Select
                Case Else
                    sb.Append(c)
            End Select
        Next
        Return sb.ToString
    End Function

    Sub Test(s As String)
        Console.WriteLine("Input  : {0}", s)
        Console.WriteLine("Output : {0}", RemoveVowels(s))
    End Sub

    Sub Main()
        Test("Visual Basic .NET")
    End Sub

End Module
