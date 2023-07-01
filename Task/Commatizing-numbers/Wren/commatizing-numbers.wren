var commatize = Fn.new { |s, start, step, sep|
    var addSeps = Fn.new { |n, dp|
        var lz = ""
        if (!dp && n.startsWith("0") && n != "0") {
            var k = n.trimStart("0")
            if (k == "") k = "0"
            lz = "0" * (n.count - k.count)
            n = k
        }
        if (dp) n = n[-1..0] // invert if after decimal point
        var i = n.count - step
        while (i >= 1) {
            n = n[0...i] + sep + n[i..-1]
            i = i - step
        }
        if (dp) n = n[-1..0] // invert back
        return lz + n
    }

    var t = s.toList
    var isExponent = Fn.new { |c| "eEdDpP^∙x↑*⁰¹²³⁴⁵⁶⁷⁸⁹".contains(c) }
    var acc = (start == 0) ? "" : t.toList[0...start].join()
    var n = ""
    var dp = false
    for (j in start...t.count) {
        var c = t[j].codePoints[0]
        if (c >= 48 && c <= 57) {
            n = n + t[j]
            if (j == t.count-1) {
                if (acc != "" && isExponent.call(acc[-1])) {
                    acc = s
                } else {
                    acc = acc + addSeps.call(n, dp)
                }
            }
        } else if (n != "") {
            if (acc != "" && isExponent.call(acc[-1])) {
                acc = s
                break
            } else if (t[j] != ".") {
                acc = acc + addSeps.call(n, dp) + t[j..-1].join()
                break
            } else {
                acc = acc + addSeps.call(n, dp) + t[j]
                dp = true
                n = ""
            }
        } else {
            acc = acc + t[j]
        }
    }

    System.print(s)
    System.print(acc)
    System.print()
}

// special version of the above which uses defaults for start, step and sep.
var commatize2 = Fn.new { |s| commatize.call(s, 0, 3, ",") }

commatize.call("123456789.123456789", 0, 2, "*")
commatize.call(".123456789", 0, 3, "-")
commatize.call("57256.1D-4", 0, 4, "__")
commatize.call("pi=3.14159265358979323846264338327950288419716939937510582097494459231", 0, 5, " ")
commatize.call("The author has two Z$100000000000000 Zimbabwe notes (100 trillion).", 0, 3, ".")

var defaults = [
    "\"-in Aus$+1411.8millions\"",
    "===US$0017440 millions=== (in 2000 dollars)",
    "123.e8000 is pretty big.",
    "The land area of the earth is 57268900(29\% of the surface) square miles.",
    "Ain't no numbers in this here words, nohow, no way, Jose.",
    "James was never known as 0000000007",
    "Arthur Eddington wrote: I believe there are 15747724136275002577605653961181555468044717914527116709366231425076185631031296 protons in the universe.",
    "   $-140000±100 millions.",
    "6/9/1946 was a good year for some."
]

defaults.each { |d| commatize2.call(d) }
