import "./fmt" for Fmt

class Prefix {
    construct new(length, broken) {
        _length = length
        _broken = broken
    }
    length { _length }
    broken { _broken }
}

var wordBreak = Fn.new { |d, s|
    if (s == "") return [[], true]
    var bp = [Prefix.new(0, [])]
    for (end in 1..s.count) {
        for (i in bp.count-1..0) {
            var w = s[bp[i].length...end]
            if (d[w]) {
                var b = bp[i].broken.toList
                b.add(w)
                if (end == s.count) return [b, true]
                bp.add(Prefix.new(end, b))
                break
            }
        }
    }
    return [[], false]
}

var words = ["a", "bc", "abc", "cd", "b"]
var d = {}
words.each { |w| d[w] = true }
for (s in ["abcd", "abbc", "abcbcd", "acdbc", "abcdd"]) {
    var res = wordBreak.call(d, s)
    if (res[1]) {
        Fmt.print("$s: $s", s, res[0].join(" "))
    } else {
        System.print("can't break")
    }
}
