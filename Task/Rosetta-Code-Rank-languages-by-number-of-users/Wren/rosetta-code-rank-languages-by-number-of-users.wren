import "os" for Process
import "timer" for Now
import "./xsequence" for XDocument
import "./fmt" for Fmt

var urlBase = "https://rosettacode.org/w/api.php?action=query&format=xml&generator=categorymembers&gcmtitle=Category:Language\%20users&gcmlimit=500&prop=categoryinfo"

var over100s = []
var url = urlBase
while (true) {
    var content = Process.read("curl -s -L \"%(url)\"")
    var doc = XDocument.parse(content)
    for (p in doc.root.element("query").element("pages").elements("page")) {
        if (p.attributeValue("ns") == "14") {
            var ci = p.element("categoryinfo")
            var numUsers = ci.attributeValue("pages", Num, 0)
            if (numUsers >= 100) {
                var language = p.attributeValue("title")[9..-6]
                over100s.add([language, numUsers])
            }
        }
    }
    var cel = doc.root.element("continue")
    if (!cel) break
    var gcmcont = "&gcmcontinue=%(cel.attribute("gcmcontinue").value)"
    var cont    = "&continue=%(cel.attribute("continue").value)"
    url = urlBase + gcmcont + cont
}
over100s.sort { |a, b| a[1] > b[1] }
var date = "%(Now.day) %(Now.monthName), %(Now.year)"
System.print("Languages with at least 100 users as at %(date):\n")
var rank = 0
var lastScore = 0
var lastRank = 0
for (i in 0...over100s.count) {
    var pair = over100s[i]
    var eq = " "
    rank = i + 1
    if (lastScore == pair[1]) {
        eq = "="
        rank = lastRank
    } else {
        lastScore = pair[1]
        lastRank = rank
    }
    Fmt.print("$-2d$s  $-11s  $d", rank, eq, pair[0], pair[1])
}
