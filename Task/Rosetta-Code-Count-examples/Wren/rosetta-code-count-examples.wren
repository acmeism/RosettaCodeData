import "os" for Process
import "./pattern" for Pattern

var url = "https://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"
var content = Process.read("curl -s -L \"%(url)\"") // url needs quotes as it contains '&'
var p = Pattern.new("title/=\"[+1^\"]\"")
var matches = p.findAll(content)
for (m in matches.take(25)) { // limit to first 25
    var title = m.capsText[0].replace("&#039;", "'").replace("&quot;", "\"")
    var title2 = title.replace(" ", "_").replace("+", "\%2B")
    var taskUrl = "https://www.rosettacode.org/w/index.php?title=%(title2)&action=raw"
    var taskContent = Process.read("curl -s -L \"%(taskUrl)\"")
    var lines = taskContent.split("\n")
    var count = lines.count { |line| line.trim().startsWith("=={{header|") }
    System.print("%(title) : %(count) examples")
}
