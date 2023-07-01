var csv =
    "Character,Speech\n" +
    "The multitude,The messiah! Show us the messiah!\n" +
    "Brians mother,<angry>Now you listen here! He's not the messiah; " +
    "he's a very naughty boy! Now go away!</angry>\n" +
    "The multitude,Who are you?\n" +
    "Brians mother,I'm his mother; that's who!\n" +
    "The multitude,Behold his mother! Behold his mother!"

var i = "   "    // indent
var ii = i + i   // double indent
var iii = ii + i // triple indent
var sb = "<table>\n%(i)<tr>\n%(ii)<td>"
for (c in csv) {
    sb = sb + ((c == "\n") ? "</td>\n%(i)</tr>\n%(i)<tr>\n%(ii)<td>" :
               (c == ",")  ? "</td>\n%(ii)<td>" :
               (c == "&")  ? "&amp;"  :
               (c == "'")  ? "&apos;" :
               (c == "<")  ? "&lt;"   :
               (c == ">")  ? "&gt;"   : c)
}
sb = sb + "</td>\n%(i)</tr>\n</table>"
System.print(sb)
System.print()

// now using first row as a table header
sb = "<table>\n%(i)<thead>\n%(ii)<tr>\n%(iii)<td>"
var hLength = csv.indexOf("\n") + 1  // find length of first row including CR
for (c in csv.take(hLength)) {
    sb = sb + ((c == "\n") ? "</td>\n%(ii)</tr>\n%(i)</thead>\n%(i)<tbody>\n%(ii)<tr>\n%(iii)<td>" :
               (c == ",")  ? "</td>\n%(iii)<td>" : c)
}
for (c in csv.skip(hLength)) {
    sb = sb + ((c == "\n") ? "</td>\n%(ii)</tr>\n%(ii)<tr>\n%(iii)<td>" :
               (c == ",")  ? "</td>\n%(iii)<td>" :
               (c == "&")  ? "&amp;"  :
               (c == "'")  ? "&apos;" :
               (c == "<")  ? "&lt;"   :
               (c == ">")  ? "&gt;"   : c)
}
sb = sb + "</td>\n%(ii)</tr>\n%(i)</tbody>\n</table>"
System.print(sb)
