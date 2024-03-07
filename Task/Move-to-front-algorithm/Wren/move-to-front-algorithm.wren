import "./fmt" for Fmt
import "./seq" for Lst

var encode = Fn.new { |s|
    if (s.isEmpty) return []
    var symbols = "abcdefghijklmnopqrstuvwxyz".toList
    var result = List.filled(s.count, 0)
    var i = 0
    for (c in s) {
        var index = Lst.indexOf(symbols, c)
        if (index == -1) Fiber.abort("%(s) contains a non-alphabetic character")
        result[i] = index
        if (index > 0) {
            for (j in index-1..0) symbols[j + 1] = symbols[j]
            symbols[0] = c
        }
        i = i + 1
    }
    return result
}

var decode = Fn.new { |a|
    if (a.isEmpty) return ""
    var symbols = "abcdefghijklmnopqrstuvwxyz".toList
    var result = List.filled(a.count, "")
    var i = 0
    for (n in a) {
        if (n < 0 || n > 25) Fiber.abort("%(a) contains an invalid number")
        result[i] = symbols[n]
        if (n > 0) {
            for (j in n-1..0) symbols[j + 1] = symbols[j]
            symbols[0] = result[i]
        }
        i = i + 1
    }
    return result.join()
}

var strings = ["broood", "bananaaa", "hiphophiphop"]
var encoded = List.filled(strings.count, null)
var i = 0
for (s in strings) {
    encoded[i] = encode.call(s)
    Fmt.print("$-12s -> $n", s, encoded[i])
    i = i + 1
}
System.print()
var decoded = List.filled(encoded.count, null)
i = 0
for (a in encoded) {
    decoded[i] = decode.call(a)
    var correct = (decoded[i] == strings[i]) ? "correct" : "incorrect"
    Fmt.print("$-38n -> $-12s -> $s", a, decoded[i], correct)
    i = i + 1
}
