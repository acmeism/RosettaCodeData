/* Rosetta_Code_Rank_languages_by_popularity.wren */

import "./pattern" for Pattern
import "./fmt" for Fmt

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

var p1 = Pattern.new("> <a href/=\"//wiki//Category:+1^\"\" title/=\"Category:[+1^\"]\">+1^,, [+1^ ] page")
var p2 = Pattern.new("subcatfrom/=[+1^#/#mw-subcategories]\"")

var findLangs = Fn.new {
    var url = "https://rosettacode.org/w/index.php?title=Category:Programming_Languages"
    var subcatfrom = ""
    var langs = []
    while (true) {
        var content = getContent.call(url + subcatfrom)
        var matches1 = p1.findAll(content)
        for (m in matches1) {
            var name = m.capsText[0]
            var tasks = Num.fromString(m.capsText[1].replace(",", ""))
            langs.add([name, tasks])
        }
        var m2 = p2.find(content)
        if (m2) subcatfrom = "&subcatfrom=%(m2.capsText[0])" else break
    }
    return langs
}

var langs = findLangs.call()
langs.sort { |a, b| a[1] > b[1] }
System.print("Languages with most examples as at 3 February, 2024:")
var rank = 0
var lastScore = 0
var lastRank = 0
for (i in 0...langs.count) {
    var pair = langs[i]
    var eq = " "
    rank = i + 1
    if (lastScore == pair[1]) {
        eq = "="
        rank = lastRank
    } else {
        lastScore = pair[1]
        lastRank = rank
    }
    Fmt.print("$-3d$s  $-20s  $,5d", rank, eq, pair[0], pair[1])
}
