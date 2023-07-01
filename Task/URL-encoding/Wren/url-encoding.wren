import "/fmt" for Fmt

var urlEncode = Fn.new { |url|
    var res = ""
    for (b in url.bytes) {
        if ((b >= 48 && b <= 57) || (b >= 65 && b <= 90) || (b >= 97 && b <= 122)) {
            res = res + String.fromByte(b)
        } else {
            res = res + Fmt.swrite("\%$2X", b)
        }
    }
    return res
}

var urls = [
    "http://foo bar/",
    "mailto:\"Ivan Aim\" <ivan.aim@email.com>",
    "mailto:\"Irma User\" <irma.user@mail.com>",
    "http://foo.bar.com/~user-name/_subdir/*~.html"
]
for (url in urls) System.print(urlEncode.call(url))
