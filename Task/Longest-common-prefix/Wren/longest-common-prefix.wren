import "./fmt" for Fmt

var lcp = Fn.new { |sa|
    var size = sa.count
    if (size == 0) return ""
    if (size == 1) return sa[0]
    var minLen = sa.skip(1).reduce(sa[0].count) { |min, s|  s.count < min ? s.count : min }
    var oldPrefix = ""
    for (i in 1..minLen) {
        var newPrefix = sa[0][0...i]
        for (j in 1...size) if (!sa[j].startsWith(newPrefix)) return oldPrefix
        oldPrefix = newPrefix
    }
    return oldPrefix
}

var lists = [
    ["interspecies","interstellar","interstate"],
    ["throne","throne"],
    ["throne","dungeon"],
    ["throne","","throne"],
    ["cheese"],
    [""],
    [],
    ["prefix","suffix"],
    ["foo","foobar"]
]

System.print("The longest common prefixes of the following collections of strings are:\n")
for (sa in lists) {
    Fmt.print("  $-46s = $q", Fmt.v("q", 0, sa), lcp.call(sa))
}
