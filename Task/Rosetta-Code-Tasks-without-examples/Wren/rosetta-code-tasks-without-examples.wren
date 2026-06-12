import "os" for Process
import "./pattern" for Pattern

var unescs = [
    ["_", " "],
    ["\%252B", "+"],
    ["\%27", "'"],
    ["\%C3\%A9", "é"],
    ["\%E2\%80\%93", "–"],
    ["\%22", "\""],
    ["\%C3\%B6", "ö"],
    ["\%E2\%80\%99", "’"],
    ["\%C3\%A8", "è"],
    ["\%C5\%91", "ő"],
]

var unescape = Fn.new { |text|
    for (u in unescs) text = text.replace(u[0], u[1])
    return text
}

var url = "https://rosettacode.org/wiki/Category:Programming_Tasks"
var content = Process.read("curl -s -L %(url)")
var p1 = Pattern.new("<li><a href/=\"//wiki//[+1^\"]\"")
var p2 = Pattern.new("<~//+0^>>")
var matches = p1.findAll(content)
var tasks = matches.map { |m| m.capsText[0] }.toList
for (task in tasks.take(3)) {  // just show the first 3 say
    var taskUrl = "https://rosettacode.org/wiki/" + task
    var html = Process.read("curl -s -L %(taskUrl)")
    var text = "using any language you may know.</div>"
    var start = html.indexOf(text)
    var end = html.indexOf("<meta property=\"mw:PageProp/toc\" />")
    html = html[start + text.count...end]
    text = p2.replaceAll(html, "").replace("&#160;", "").trim()
    var title = unescape.call(task)
    System.print("\n****** %(title) ******\n")
    System.print(text)
}
