import "./fmt" for Fmt

var textBetween = Fn.new { |str, start, end|
    if (!((start is String) && start != "") && !((end is String) && end != "")) {
        Fiber.abort("Start and end must both be non-empty strings.")
    }
    if (str == "") return str
    var s = (start == "start") ? 0 : str.indexOf(start)
    if (s == -1) return ""
    var si = (start == "start") ? 0 : s + start.count
    var e = (end == "end") ? str.count : str.indexOf(end, si)
    if (e == -1) return str[si..-1]
    return str[si...e]
}

var texts = [
    "Hello Rosetta Code world",
    "Hello Rosetta Code world",
    "Hello Rosetta Code world",
    "</div><div style=\"chinese\">你好嗎</div>",
    "<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">",
    "<table style=\"myTable\"><tr><td>hello world</td></tr></table>",
    "The quick brown fox jumps over the lazy other fox",
    "One fish two fish red fish blue fish",
    "FooBarBazFooBuxQuux"
]

var starts = [
    "Hello ", "start", "Hello ", "<div style=\"chinese\">",
    "<text>", "<table>", "quick ", "fish ", "Foo"
]

var ends = [
    " world", " world", "end", "</div>", "<table>",
    "</table>", " fox", " red", "Foo"
]

var i = 0
for (text in texts) {
    Fmt.print("Text: $q", text)
    Fmt.print("Start delimiter: $q", starts[i])
    Fmt.print("End delimiter: $q", ends[i])
    var b = textBetween.call(text, starts[i], ends[i])
    Fmt.print("Output: $q\n", b)
    i = i + 1
}
