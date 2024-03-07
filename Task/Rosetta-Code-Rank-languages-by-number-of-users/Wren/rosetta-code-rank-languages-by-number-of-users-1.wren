/* Rosetta_Code_Rank_languages_by_number_of_users.wren */

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

var p = Pattern.new(" User\">[+1^<]<//a>\u200f\u200e ([#13/d] member~s)")
var url = "https://rosettacode.org/w/index.php?title=Special:Categories&limit=5000"
var content = getContent.call(url)
var matches = p.findAll(content)
var over100s = []
for (m in matches) {
    var numUsers = Num.fromString(m.capsText[1])
    if (numUsers >= 100) {
       var language = m.capsText[0][0..-6]
       over100s.add([language, numUsers])
    }
}
over100s.sort { |a, b| a[1] > b[1] }
System.print("Languages with at least 100 users as at 3 February, 2024:")
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
