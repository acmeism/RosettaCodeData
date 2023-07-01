Module Program
    Sub Main()
        Console.OutputEncoding = Text.Encoding.Unicode
        Dim cheat_harder = Function(scale As Integer) <span style=<%= $"font-size:{scale}%;" %>>&#x262f;</span>
        Console.WriteLine(<div><%= cheat_harder(700) %><%= cheat_harder(350) %></div>)
    End Sub
End Module
