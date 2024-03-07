/* Yahoo_search_interface.wren */

import "./pattern" for Pattern

class YahooSearch {
    construct new(url, title, desc) {
        _url = url
        _title = title
        _desc = desc
    }

    toString { "URL: %(_url)\nTitle: %(_title)\nDescription: %(_desc)\n" }
}

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

var p1 = Pattern.new("class/=\" d-ib ls-05 fz-20 lh-26 td-hu tc va-bot mxw-100p\" href/=\"[+1^\"]\"")
var p2 = Pattern.new("class/=\" d-ib p-abs t-0 l-0 fz-14 lh-20 fc-obsidian wr-bw ls-n pb-4\">[+1^<]<")
var p3 = Pattern.new("<span class/=\" fc-falcon\">[+1^<]<")

var pageSize = 7
var totalCount = 0

var yahooSearch = Fn.new { |query, page|
    System.print("Page %(page):\n=======\n")
    var next = (page - 1) * pageSize + 1
    var url = "https://search.yahoo.com/search?fr=opensearch&pz=%(pageSize)&p=%(query)&b=%(next)"
    var content = getContent.call(url).replace("<b>", "").replace("</b>", "")
    var matches1 = p1.findAll(content)
    var count = matches1.count
    if (count == 0) return false
    var matches2 = p2.findAll(content)
    var matches3 = p3.findAll(content)
    totalCount = totalCount + count
    var ys = List.filled(count, null)
    for (i in 0...count) {
        var url   = matches1[i].capsText[0]
        var title = matches2[i].capsText[0]
        var desc  = matches3[i].capsText[0].replace("&#39;", "'")
        ys[i] = YahooSearch.new(url, title, desc)
    }
    System.print(ys.join("\n"))
    return true
}

var page = 1
var limit = 2
var query = "rosettacode"
System.print("Searching for '%(query)' on Yahoo!\n")
while (page <= limit && yahooSearch.call(query, page)) {
    page = page + 1
    System.print()
}
System.print("Displayed %(limit) pages with a total of %(totalCount) entries.")
curl.easyCleanup()
