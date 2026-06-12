Module Module1
    Function TextBetween(source As String, pre As String, suf As String) As String
        Dim startIndex As Integer

        If pre = "start" Then
            startIndex = 0
        Else
            startIndex = source.IndexOf(pre)
            If startIndex < 0 Then
                Return ""
            End If
            startIndex += pre.Length
        End If

        Dim endIndex = source.IndexOf(suf, startIndex)
        If endIndex < 0 OrElse suf = "end" Then
            Return source.Substring(startIndex)
        End If
        Return source.Substring(startIndex, endIndex - startIndex)
    End Function

    Sub Print(s As String, b As String, e As String)
        Console.WriteLine("text: '{0}'", s)
        Console.WriteLine("start: '{0}'", b)
        Console.WriteLine("end: '{0}'", e)
        Console.WriteLine("result: '{0}'", TextBetween(s, b, e))
        Console.WriteLine()
    End Sub

    Sub Main()
        Console.OutputEncoding = System.Text.Encoding.UTF8

        Print("Hello Rosetta Code world", "Hello ", " world")
        Print("Hello Rosetta Code world", "start", " world")
        Print("Hello Rosetta Code world", "Hello ", "end")
        Print("</div><div style=""chinese"">你好嗎</div>", "<div style=""chinese"">", "</div>")
        Print("<text>Hello <span>Rosetta Code</span> world</text><table style=""myTable"">", "<text>", "<table>")
        Print("<table style=""myTable""><tr><td>hello world</td></tr></table>", "<table>", "</table>")
        Print("The quick brown fox jumps over the lazy other fox", "quick ", " fox")
        Print("One fish two fish red fish blue fish", "fish ", " red")
        Print("FooBarBazFooBuxQuux", "Foo", "Foo")
    End Sub

End Module
