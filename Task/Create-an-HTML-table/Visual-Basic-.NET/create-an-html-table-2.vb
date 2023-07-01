Module Program
    Sub Main()
        Dim rand As Func(Of Integer, Integer) = AddressOf New Random(0).Next

        Dim cols = {"", "X", "Y", "Z"}
        Dim rows = 3

        Dim result =
<html>
    <body>
        <table>
            <colgroup>
                <%= Iterator Function()
                        For Each col In cols
                            Yield <col style="text-align: left;" />
                        Next
                    End Function() %>
            </colgroup>
            <thead>
                <tr>
                    <%= Iterator Function()
                            For Each col In cols
                                Yield <td><%= col %></td>
                            Next
                        End Function() %>
                </tr>
            </thead>
            <tbody>
                <%= Iterator Function()
                        For r = 1 To rows
                            Yield _
                                <tr>
                                    <%= Iterator Function()
                                            For key = 0 To cols.Length - 1
                                                Dim col = cols(key)
                                                Yield <td><%= If(key > 0, rand(10000), r) %></td>
                                            Next
                                        End Function() %>
                                </tr>
                        Next
                    End Function() %>
            </tbody>
        </table>
    </body>
</html>

        Console.WriteLine(result)
    End Sub
End Module
