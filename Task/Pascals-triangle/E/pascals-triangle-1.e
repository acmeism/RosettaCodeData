def pascalsTriangle(n, out) {
    def row := [].diverge(int)
    out.print("<table style='text-align: center; border: 0; border-collapse: collapse;'>")
    for y in 1..n {
        out.print("<tr>")
        row.push(1)
        def skip := n - y
        if (skip > 0) {
            out.print(`<td colspan="$skip"></td>`)
        }
        for x => v in row {
            out.print(`<td>$v</td><td></td>`)
        }
        for i in (1..!y).descending() {
            row[i] += row[i - 1]
        }
        out.println("</tr>")
    }
    out.print("</table>")
}
