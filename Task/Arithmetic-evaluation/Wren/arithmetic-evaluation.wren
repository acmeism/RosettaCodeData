import "/pattern" for Pattern

/* if string is empty, returns zero */
var toDoubleOrZero = Fn.new { |s|
    var n = Num.fromString(s)
    return n ? n : 0
}

var multiply = Fn.new { |s|
    var b = s.split("*").map { |t| toDoubleOrZero.call(t) }.toList
    return (b[0] * b[1]).toString
}

var divide = Fn.new { |s|
    var b = s.split("/").map { |t| toDoubleOrZero.call(t) }.toList
    return (b[0] / b[1]).toString
}

var add = Fn.new { |s|
    var p1 = Pattern.new("/+", Pattern.start)
    var p2 = Pattern.new("+1/+")
    var t = p1.replaceAll(s, "")
    t = p2.replaceAll(t, "+")
    var b = t.split("+").map { |u| toDoubleOrZero.call(u) }.toList
    return (b[0] + b[1]).toString
}

var subtract = Fn.new { |s|
    var p = Pattern.new("[/+-|-/+]")
    var t = p.replaceAll(s, "-")
    if (t.contains("--")) return add.call(t.replace("--", "+"))
    var b = t.split("-").map { |u| toDoubleOrZero.call(u) }.toList
    return ((b.count == 3) ? -b[1] - b[2] : b[0] - b[1]).toString
}

var evalExp = Fn.new { |s|
    var p = Pattern.new("[(|)|/s]")
    var t = p.replaceAll(s, "")
    var i = "*/"
    var pMD = Pattern.new("+1/f/i~/n+1/f", Pattern.within, i)
    var pM  = Pattern.new("*")
    var pAS = Pattern.new("~-+1/f+1/n+1/f")
    var pA  = Pattern.new("/d/+")

    while (true) {
        var match = pMD.find(t)
        if (!match) break
        var exp = match.text
        var match2 = pM.find(exp)
        t = match2 ? t.replace(exp, multiply.call(exp)) : t.replace(exp, divide.call(exp))
    }

    while (true) {
        var match = pAS.find(t)
        if (!match) break
        var exp = match.text
        var match2 = pA.find(exp)
        t = match2 ? t.replace(exp, add.call(exp)) : t.replace(exp, subtract.call(exp))
    }
    return t
}

var evalArithmeticExp = Fn.new { |s|
    var p1 = Pattern.new("/s")
    var p2 = Pattern.new("/+", Pattern.start)
    var t = p1.replaceAll(s, "")
    t = p2.replaceAll(t, "")
    var i = "()"
    var pPara = Pattern.new("(+0/I)", Pattern.within, i)
    while (true) {
        var match = pPara.find(t)
        if (!match) break
        var exp = match.text
        t = t.replace(exp, evalExp.call(exp))
    }
    return toDoubleOrZero.call(evalExp.call(t))
}

[
    "2+3",
    "2+3/4",
    "2*3-4",
    "2*(3+4)+5/6",
    "2 * (3 + (4 * 5 + (6 * 7) * 8) - 9) * 10",
    "2*-3--4+-0.25",
    "-4 - 3",
    "((((2))))+ 3 * 5",
    "1 + 2 * (3 + (4 * 5 + 6 * 7 * 8) - 9) / 10",
    "1 + 2*(3 - 2*(3 - 2)*((2 - 4)*5 - 22/(7 + 2*(3 - 1)) - 1)) + 1"
].each { |s| System.print("%(s) = %(evalArithmeticExp.call(s))") }
