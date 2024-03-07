/* Web_scraping.wren */

import "./pattern" for Pattern

var CURLOPT_URL = 10002
var CURLOPT_FOLLOWLOCATION = 52
var CURLOPT_WRITEFUNCTION = 20011
var CURLOPT_WRITEDATA = 10001

var BUFSIZE = 16384 * 4

foreign class Buffer {
    construct new(size) {}

    // returns buffer contents as a string
    foreign value
}

foreign class Curl {
    construct easyInit() {}

    foreign easySetOpt(opt, param)

    foreign easyPerform()

    foreign easyCleanup()
}

var buffer = Buffer.new(BUFSIZE)
var curl = Curl.easyInit()
curl.easySetOpt(CURLOPT_URL, "https://rosettacode.org/wiki/Talk:Web_scraping")
curl.easySetOpt(CURLOPT_FOLLOWLOCATION, 1)
curl.easySetOpt(CURLOPT_WRITEFUNCTION, 0) // write function to be supplied by C
curl.easySetOpt(CURLOPT_WRITEDATA, buffer)

curl.easyPerform()
curl.easyCleanup()

var html = buffer.value
var ix = html.indexOf("(UTC)")
ix = html.indexOf("(UTC)", ix + 1) // skip the site notice
if (ix == -1) {
    System.print("UTC time not found.")
    return
}
var p = Pattern.new("/d/d:/d/d, #12/d +1/a =4/d")
var m = p.find(html[(ix - 30).max(0)...ix])
System.print(m.text)
