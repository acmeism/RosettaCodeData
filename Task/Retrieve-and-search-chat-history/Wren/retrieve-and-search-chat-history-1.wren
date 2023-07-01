/* retrieve_and_search_chat_history.wren */

import "./date" for Date

var CURLOPT_URL = 10002
var CURLOPT_FOLLOWLOCATION = 52
var CURLOPT_WRITEFUNCTION = 20011
var CURLOPT_WRITEDATA = 10001

class C {
    foreign static searchStr
    foreign static utcNow // format will be yyyy-mm-dd hh:MM:ss
}

foreign class Buffer {
    construct new() {}   // C will allocate buffer of a suitable size

    foreign value        // returns buffer contents as a string
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

var baseUrl = "http://tclers.tk/conferences/tcl/"
var searchStr = C.searchStr
var now = C.utcNow
var d = Date.parse(now)
d = d.adjustTime("CET") // adjust to German time
var fmt = "mmmm| |d| |yyyy| |H|:|MM|am| |zz|"
System.print("It's %(d.format(fmt)) just now in Germany.")
System.print("Searching for '%(searchStr)' in the TCL Chatroom logs for the last 10 days:\n")
for (i in 0..9) {
    var date = d.toString.split(" ")[0]
    var url = baseUrl + date + ".tcl"
    var underline = "-" * url.count
    var content = getContent.call(url)
    var lines = content.split("\n")
    System.print("%(url)")
    System.print(underline)
    for (line in lines) {
        if (line.indexOf(searchStr) >= 0) System.print(line)
    }
    System.print(underline + "\n")
    d = d.addDays(-1)
}

curl.easyCleanup()
