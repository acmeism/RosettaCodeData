import "random" for Random
import "./fmt" for Fmt

var r = Random.new()
var sb = ""
var i = "   "  // indent
sb = sb + "<html>\n<head>\n"
sb = sb + "<style>\n"
sb = sb + "table, th, td  { border: 1px solid black; }\n"
sb = sb + "th, td { text-align: right; }\n"
sb = sb + "</style>\n</head>\n<body>\n"
sb = sb + "<table style=\"width:60\%\">\n"
sb = sb + "%(i)<thead>\n"
sb = sb + "%(i)%(i)<tr><th></th>"
for (c in "XYZ") sb = sb + "<th>%(c)</th>"
sb = sb + "</tr>\n"
sb = sb + "%(i)</thead>\n"
sb = sb + "%(i)<tbody>\n"
var f = "%(i)%(i)<tr><td>$d</td><td>$d</td><td>$d</td><td>$d</td></tr>\n"
for (j in 1..4) sb = sb + Fmt.swrite(f, j, r.int(1e4), r.int(1e4), r.int(1e4))
sb = sb + "%(i)</tbody>\n"
sb = sb + "</table>\n"
sb = sb + "</body>\n</html>"
System.print(sb)
