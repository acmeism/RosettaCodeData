/* Rosetta_Code_Count_examples.wren */

import "./pattern" for Pattern

var CURLOPT_URL = 10002
var CURLOPT_FOLLOWLOCATION = 52
var CURLOPT_WRITEFUNCTION = 20011
var CURLOPT_WRITEDATA = 10001

foreign class Buffer {
    construct new() {}  // C will allocate buffer of a suitable size

    foreign value       // returns buffer contents as a string
}

foreign class Curl {
    construct easyInit() {}

    foreign easySetOpt(opt, param)

    foreign easyPerform()

    foreign easyCleanup()
}

var curl = Curl.easyInit()

var getContent = Fn.new { |url|
    var buffer = Buffer.new()
    curl.easySetOpt(CURLOPT_URL, url)
    curl.easySetOpt(CURLOPT_FOLLOWLOCATION, 1)
    curl.easySetOpt(CURLOPT_WRITEFUNCTION, 0)  // write function to be supplied by C
    curl.easySetOpt(CURLOPT_WRITEDATA, buffer)
    curl.easyPerform()
    return buffer.value
}

var url = "https://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"
var content = getContent.call(url)
var p = Pattern.new("title/=\"[+1^\"]\"")
var matches = p.findAll(content)
for (m in matches) {
    var title = m.capsText[0].replace("&#039;", "'").replace("&quot;", "\"")
    var title2 = title.replace(" ", "_").replace("+", "\%252B")
    var taskUrl = "https://www.rosettacode.org/w/index.php?title=%(title2)&action=raw"
    var taskContent = getContent.call(taskUrl)
    var lines = taskContent.split("\n")
    var count = lines.count { |line| line.trim().startsWith("=={{header|") }
    System.print("%(title) : %(count) examples")
}

curl.easyCleanup()
