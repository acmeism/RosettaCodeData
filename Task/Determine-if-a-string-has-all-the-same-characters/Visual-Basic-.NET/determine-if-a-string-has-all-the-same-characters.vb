Module Module1

    Sub Analyze(s As String)
        Console.WriteLine("Examining [{0}] which has a length of {1}:", s, s.Length)
        If s.Length > 1 Then
            Dim b = s(0)
            For i = 1 To s.Length
                Dim c = s(i - 1)
                If c <> b Then
                    Console.WriteLine("    Not all characters in the string are the same.")
                    Console.WriteLine("    '{0}' (0x{1:X02}) is different at position {2}", c, AscW(c), i - 1)
                    Return
                End If
            Next
        End If
        Console.WriteLine("    All characters in the string are the same.")
    End Sub

    Sub Main()
        Dim strs() = {"", "   ", "2", "333", ".55", "tttTTT", "4444 444k"}
        For Each s In strs
            Analyze(s)
        Next
    End Sub

End Module
