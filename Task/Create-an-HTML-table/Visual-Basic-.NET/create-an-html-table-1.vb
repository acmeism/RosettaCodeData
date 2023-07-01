Module Program
    Sub Main()
        Const ROWS = 3
        Const COLS = 3

        Dim rand As New Random(0)
        Dim getNumber = Function() rand.Next(10000)

        Dim result =
<table cellspacing="4" style="text-align:right; border:1px solid;">
    <tr>
        <th></th>
        <th>X</th>
        <th>Y</th>
        <th>Z</th>
    </tr>
    <%= From c In Enumerable.Range(1, COLS) Select
        <tr>
            <th><%= c %></th>
            <%= From r In Enumerable.Range(1, ROWS) Select
                <td><%= getNumber() %></td>
            %>
        </tr>
    %>
</table>

        Console.WriteLine(result)
    End Sub
End Module
