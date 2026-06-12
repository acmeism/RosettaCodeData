import "./fmt" for Fmt

var parseRange = Fn.new { |r|
    if (r == "") return ["{}"] // rangeless, empty
    var sp = r.split("..")
    if (sp.count == 1) return ["{%(r)}"] // rangeless, random value
    var sta = sp[0]
    var end = sp[1]
    var inc = (sp.count == 2) ? "1" : sp[2]
    var n1 = Num.fromString(sta)
    var n2 = Num.fromString(end)
    var n3 = Num.fromString(inc)
    if (!n3) return ["{%(r)}"] // increment isn't a number
    var numeric = n1 && n2
    if (!numeric) {
        if ((n1 && !n2) || (!n1 && n2)) return ["{%(r)}"] // mixed numeric/alpha not expanded
        if (sta.count != 1 || end.count != 1) return ["{%(r)}"] // start/end are not both single alpha
        n1 = sta.codePoints[0]
        n2 = end.codePoints[0]
    }
    var width = 1
    if (numeric) width = (sta.count < end.count) ? end.count : sta.count
    if (n3 == 0) return (numeric) ? [Fmt.dz(width, n1)] : [sta] // zero increment
    var res = []
    var asc = n1 < n2
    if (n3 < 0) {
        asc = !asc
        var t = n1
        var d = (n1 - n2).abs % (-n3)
        n1 = n2 - d * (n2 - n1).sign
        n2 = t
        n3 = -n3
    }
    var i = n1
    if (asc) {
        while (i <= n2) {
            res.add( (numeric) ? Fmt.dz(width, i) : String.fromCodePoint(i) )
            i = i + n3
        }
    } else {
        while (i >= n2) {
            res.add(( numeric) ? Fmt.dz(width, i) : String.fromCodePoint(i) )
            i = i - n3
        }
    }
    return res
}

var rangeExpand = Fn.new { |s|
    var res = [""]
    var rng = ""
    var inRng = false
    for (c in s) {
        if (c == "{" && !inRng) {
            inRng = true
            rng = ""
        } else if (c == "}" && inRng) {
            var rngRes = parseRange.call(rng)
            var rngCount = rngRes.count
            var res2 = []
            for (i in 0...res.count) {
                for (j in 0...rngCount) res2.add(res[i] + rngRes[j])
            }
            res = res2
            inRng = false
        } else if (inRng) {
            rng = rng + c
        } else {
            for (i in 0...res.count) res[i] = res[i] + c
        }
    }
    if (inRng) for (i in 0...res.count) res[i] = res[i] + "{" + rng // unmatched braces
    return res
}

var examples = [
    "simpleNumberRising{1..3}.txt",
    "simpleAlphaDescending-{Z..X}.txt",
    "steppedDownAndPadded-{10..00..5}.txt",
    "minusSignFlipsSequence {030..20..-5}.txt",
    "reverseSteppedNumberRising{1..6..-2}.txt",
    "combined-{Q..P}{2..1}.txt",
    "emoji{🌵..🌶}{🌽..🌾}etc",
    "li{teral",
    "rangeless{}empty",
    "rangeless{random}string",
    "mixedNumberAlpha{5..k}",
    "steppedAlphaRising{P..Z..2}.txt",
    "stops after endpoint-{02..10..3}.txt",
    "steppedNumberRising{1..6..2}.txt",
    "steppedNumberDescending{20..9..2}",
    "steppedAlphaDescending-{Z..M..2}.txt",
    "reversedSteppedAlphaDescending-{Z..M..-2}.txt"
]

for (s in examples) {
    System.write("%(s) ->\n    ")
    var res = rangeExpand.call(s)
    System.print(res.join("\n    "))
    System.print()
}
