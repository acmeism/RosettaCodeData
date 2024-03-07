import "./fmt" for Conv

var urlDecode = Fn.new { |enc|
    var res = ""
    var i = 0
    while (i < enc.count) {
        var c = enc[i]
        if (c == "\%") {
            var b = Conv.atoi(enc[i+1..i+2], 16)
            res = res + String.fromByte(b)
            i = i + 3
        } else {
            res = res + c
            i = i + 1
        }
    }
    return res
}

// We need to escape % characters in Wren as % is otherwise used for string interpolation.
var encs = [
    "http\%3A\%2F\%2Ffoo\%20bar\%2F",
    "google.com/search?q=\%60Abdu\%27l-Bah\%C3\%A1"
]
for (enc in encs)System.print(urlDecode.call(enc))
