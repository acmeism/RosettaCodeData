import httpclient, strutils, xmltree, xmlparser, cgi

proc count(s, sub: string): int =
  var i = 0
  while true:
    i = s.find(sub, i)
    if i < 0: break
    inc i
    inc result

const
  mainSite = "http://www.rosettacode.org/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"
  subSite = "http://www.rosettacode.org/mw/index.php?title=$#&action=raw"

var client = newHttpClient()
var sum = 0
for node in client.getContent(mainSite).parseXml().findAll("cm"):
  let t = node.attr("title").replace(" ", "_")
  let c = client.getContent(subSite % encodeUrl(t)).toLower().count("{{header|")
  echo t.replace("_", " "), ": ", c, " examples."
  inc sum, c

echo "\nTotal: ", sum, " examples."
