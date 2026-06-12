var lcs = Fn.new { |a|
    if (a.count == 0) return ""
    if (a.count == 1) return a[0]
    var minLen = a.reduce(a[0].count) { |min, s| (s.count < min) ? s.count : min }
    if (minLen == 0) return ""
    var res = ""
    for (i in 1..minLen) {
        var suffix = a[0][-i..-1]
        for (e in a.skip(1)) {
            if (!e.endsWith(suffix)) return res
        }
        res = suffix
    }
    return res
}

var tests = [
    ["baabababc","baabc","bbbabc"],
    ["baabababc","baabc","bbbazc"],
    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    ["longest", "common", "suffix"],
    ["suffix"],
    [""]
]
for (test in tests) System.print("%(test) -> \"%(lcs.call(test))\"")
