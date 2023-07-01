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
                <%= cols.Select(Function(__) <col style="text-align: left;"/>) %>
            </colgroup>
            <thead>
                <tr>
                    <%= cols.Select(Function(col) <td><%= col %></td>) %>
                </tr>
            </thead>
            <tbody>
                <%= Enumerable.Range(1, rows).Select(
                    Function(r) _
                        <tr>
                            <%= cols.Select(
                                    Function(col, key) <td><%= If(key > 0, rand(10000), r) %></td>)
                            %>
                        </tr>)
                %>
            </tbody>
        </table>
    </body>
</html>

        Console.WriteLine(result)
    End Sub
End Module
