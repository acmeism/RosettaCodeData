// version 1.1.3

import java.util.Random

fun main(args: Array<String>) {
    val r = Random()
    val sb = StringBuilder()
    val i = "   "  // indent
    with (sb) {
        append("<html>\n<head>\n")
        append("<style>\n")
        append("table, th, td  { border: 1px solid black; }\n")
        append("th, td { text-align: right; }\n")
        append("</style>\n</head>\n<body>\n")
        append("<table style=\"width:60%\">\n")
        append("$i<thead>\n")
        append("$i$i<tr><th></th>")
        for (c in 'X'..'Z') append("<th>$c</th>")
        append("</tr>\n")
        append("$i</thead>\n")
        append("$i<tbody>\n")
        val f = "$i$i<tr><td>%d</td><td>%d</td><td>%d</td><td>%d</td></tr>\n"
        for (j in 1..4) {
            append(f.format(j, r.nextInt(10000), r.nextInt(10000), r.nextInt(10000)))
        }
        append("$i</tbody>\n")
        append("</table>\n")
        append("</body>\n</html>")
    }
    println(sb.toString())
}
