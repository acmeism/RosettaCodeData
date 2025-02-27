import "os" for Process
import "./pattern" for Pattern

var page = "https://rosettacode.org/wiki/Talk:Web_scraping"
var html = Process.read("curl -s %(page)")
var ix = html.indexOf("(UTC)")
if (ix == -1) {
    System.print("UTC time not found.")
    return
}
var p = Pattern.new("/d/d:/d/d, #12/d +1/a =4/d")
var m = p.find(html[(ix - 30).max(0)...ix])
System.print(m.text)
