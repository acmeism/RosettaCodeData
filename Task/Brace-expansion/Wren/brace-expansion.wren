var getGroup // forward declaration

var getItem = Fn.new { |s, depth|
    var out = [""]
    while (s != "") {
        var c = s[0]
        if (depth > 0 && (c == "," || c == "}")) return [out, s]
        var cont = false
        if (c == "{") {
            var x = getGroup.call(s[1..-1], depth+1)
            if (!x[0].isEmpty) {
                var t = []
                for (a in out) {
                    for (b in x[0]) {
                        t.add(a + b)
                    }
                }
                out = t
                s = x[1]
                cont = true
            }
        }
        if (!cont) {
            if (c == "\\" && s.count > 1) {
                c = c + s[1]
                s = s[1..-1]
            }
            out = out.map { |a| a + c }.toList
            s = s[1..-1]
        }
    }
    return [out, s]
}

getGroup = Fn.new { |s, depth|
    var out = []
    var comma = false
    while (s != "") {
        var t = getItem.call(s, depth)
        var g = t[0]
        s = t[1]
        if (s == "") break
        out.addAll(g)
        if (s[0] == "}") {
            if (comma) return [out, s[1..-1]]
            return [out.map { |a| "{" + a + "}" }.toList, s[1..-1]]
        }
        if (s[0] == ",") {
            comma = true
            s = s[1..-1]
       }
    }
    return [[], ""]
}

var inputs = [
     "~/{Downloads,Pictures}/*.{jpg,gif,png}",
    "It{{em,alic}iz,erat}e{d,}, please.",
    "{,{,gotta have{ ,\\, again\\, }}more }cowbell!",
    "{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}"
]
for (input in inputs) {
    System.print(input)
    for (s in getItem.call(input, 0)[0]) System.print("    " + s)
    System.print()
}
