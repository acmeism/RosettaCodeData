import "os" for Process
import "timer" for Now
import "./xsequence" for XDocument
import "./fmt" for Fmt

var urlBase = "https://rosettacode.org/w/api.php?action=query&format=xml&generator=categorymembers&gcmtitle=Category:Programming\%20Languages&gcmlimit=500&prop=categoryinfo"

var results = []
var url = urlBase
while (true) {
    var content = Process.read("curl -s -L \"%(url)\"")
    var doc = XDocument.parse(content)
    for (p in doc.root.element("query").element("pages").elements("page")) {
        if (p.attributeValue("ns") == "14") {
            var ci = p.element("categoryinfo")
            var numTasks = ci.attributeValue("pages", Num, 0)
            var language = p.attributeValue("title")[9..-1]
            results.add([language, numTasks])
        }
    }
    var cel = doc.root.element("continue")
    if (!cel) break
    var gcmcont = "&gcmcontinue=%(cel.attribute("gcmcontinue").value)"
    var cont    = "&continue=%(cel.attribute("continue").value)"
    url = urlBase + gcmcont + cont
}
results.sort { |a, b| a[1] > b[1] }
var date = "%(Now.day) %(Now.monthName), %(Now.year)"
System.print("Languages with most tasks completed as at %(date):\n")
var rank = 0
var lastScore = 0
var lastRank = 0
for (i in 0..29) {  // just show top 30
    var pair = results[i]
    var eq = " "
    rank = i + 1
    if (lastScore == pair[1]) {
        eq = "="
        rank = lastRank
    } else {
        lastScore = pair[1]
        lastRank = rank
    }
    Fmt.print("$-2d$s  $-11s  $4d", rank, eq, pair[0], pair[1])
}
