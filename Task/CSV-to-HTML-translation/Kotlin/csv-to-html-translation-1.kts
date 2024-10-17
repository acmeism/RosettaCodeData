// version 1.1.3

val csv =
    "Character,Speech\n" +
    "The multitude,The messiah! Show us the messiah!\n" +
    "Brians mother,<angry>Now you listen here! He's not the messiah; " +
    "he's a very naughty boy! Now go away!</angry>\n" +
    "The multitude,Who are you?\n" +
    "Brians mother,I'm his mother; that's who!\n" +
    "The multitude,Behold his mother! Behold his mother!"

fun main(args: Array<String>) {
    val i = "   "  // indent
    val sb = StringBuilder("<table>\n$i<tr>\n$i$i<td>")
    for (c in csv) {
        sb.append( when (c) {
            '\n' -> "</td>\n$i</tr>\n$i<tr>\n$i$i<td>"
            ','  -> "</td>\n$i$i<td>"
            '&'  -> "&amp;"
            '\'' -> "&apos;"
            '<'  -> "&lt;"
            '>'  -> "&gt;"
            else -> c.toString()
        })
    }
    sb.append("</td>\n$i</tr>\n</table>")
    println(sb.toString())
    println()

    // now using first row as a table header
    sb.setLength(0)
    sb.append("<table>\n$i<thead>\n$i$i<tr>\n$i$i$i<td>")
    val hLength = csv.indexOf('\n') + 1  // find length of first row including CR
    for (c in csv.take(hLength)) {
        sb.append( when (c) {
            '\n' -> "</td>\n$i$i</tr>\n$i</thead>\n$i<tbody>\n$i$i<tr>\n$i$i$i<td>"
            ','  -> "</td>\n$i$i$i<td>"
            else -> c.toString()
        })
    }
    for (c in csv.drop(hLength)) {
        sb.append( when (c) {
            '\n' -> "</td>\n$i$i</tr>\n$i$i<tr>\n$i$i$i<td>"
            ','  -> "</td>\n$i$i$i<td>"
            '&'  -> "&amp;"
            '\'' -> "&apos;"
            '<'  -> "&lt;"
            '>'  -> "&gt;"
            else -> c.toString()
        })
    }
    sb.append("</td>\n$i$i</tr>\n$i</tbody>\n</table>")
    println(sb.toString())
}
