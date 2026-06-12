/* URL_shortener.wren */

import "./json" for JSON
import "random" for Random

var Chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

var MethodPost = "POST"
var MethodGet = "GET"
var StatusBadRequest = 400
var StatusFound = 302
var StatusNotFound = 404

var Db = {}
var Rand = Random.new()

var GenerateKey = Fn.new { |size|
    var key = List.filled(size, null)
    var le = Chars.count
    for (i in 0...size) key[i] = Chars[Rand.int(le)]
    return key.join()
}

class ResponseWriter {
    foreign static writeHeader(statusCode)
    foreign static fprint(str)
}

class Request {
    foreign static method
    foreign static body
    foreign static urlPath
}

class Http {
    foreign static host

    static serve() {
        if (Request.method == MethodPost) {
            var body = Request.body
            var sh = JSON.parse(body)["long"]
            var short = GenerateKey.call(8)
            Db[short] = sh
            ResponseWriter.fprint("The shortened URL: http://%(host)/%(short)\n")
        } else if (Request.method == MethodGet) {
            var path = Request.urlPath[1..-1]
            if (Db.containsKey(path)) {
                redirect(Db[path], StatusFound)
            } else {
                ResponseWriter.writeHeader(StatusNotFound)
                ResponseWriter.fprint("No such shortened url: http://%(host)/%(path)\n")
            }
        } else {
            ResponseWriter.writeHeader(StatusNotFound)
            ResponseWriter.fprint("Unsupported method: %(Request.method)\n")
        }
    }

    foreign static redirect(url, code)
}
