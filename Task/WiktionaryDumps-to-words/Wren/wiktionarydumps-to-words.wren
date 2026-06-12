import "os" for Process
import "./pattern" for Pattern

var limit = 700 * 1024
var file = "https://dumps.wikimedia.org/enwiktionary/latest/enwiktionary-latest-pages-articles.xml.bz2"
var command  = "curl -s -r 0-%(limit) %(file) | bzip2 -q -d"
var lines = Process.read(command).split("\n")
var title = "<title>"
var txtOpen = "<text"
var txtClose = "</text>"
var langMark = "==French=="
var gotTextLast = false
var titleWord = ""
var p = Pattern.new("<title>[+1^<]<//title>")
for (line in lines) {
    if (line.indexOf(title) >= 0) {
        gotTextLast = false
        var m = p.find(line)
        titleWord = m ? m.capsText[0] : ""
    } else if (line.indexOf(txtOpen) >= 0) {
        gotTextLast = true
    } else if (line.indexOf(langMark) >= 0) {
        if (gotTextLast && titleWord != "") System.print(titleWord)
        gotTextLast = false
    } else if (line.indexOf(txtClose) >= 0) {
        gotTextLast = false
    }
}
