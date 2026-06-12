import "./pattern" for Pattern
import "./big" for BigRat, BigInt
import "./str" for Str
import "./ioutil" for Input

var zero = BigRat.zero

/* if string is empty, returns zero */
var toBigRatOrZero = Fn.new { |s|
    return s != "" ? BigRat.fromDecimal(s) : zero
}

var multiply = Fn.new { |s|
    var b = s.split("*").map { |t| toBigRatOrZero.call(t) }.toList
    return (b[0] * b[1]).toDecimal(100, false)
}

var divide = Fn.new { |s|
    var b = s.split("/").map { |t| toBigRatOrZero.call(t) }.toList
    if (b[1] == zero) {
        var res = b[0] == zero ? "not a number" : "infinite"
        System.print("%(res), treating denominator as 1 instead")
        b[1] = BigRat.one
    }
    return (b[0] / b[1]).toDecimal(100, false)
}

var add = Fn.new { |s|
    var p1 = Pattern.new("/+", Pattern.start)
    var p2 = Pattern.new("+1/+")
    var t = p1.replaceAll(s, "")
    t = p2.replaceAll(t, "+")
    var b = t.split("+").map { |u| toBigRatOrZero.call(u) }.toList
    return (b[0] + b[1]).toDecimal(100, false)
}

var subtract = Fn.new { |s|
    var p = Pattern.new("[/+-|-/+]")
    var t = p.replaceAll(s, "-")
    if (t.contains("--")) return add.call(t.replace("--", "+"))
    var b = t.split("-").map { |u| toBigRatOrZero.call(u) }.toList
    return ((b.count == 3) ? -b[1] - b[2] : b[0] - b[1]).toDecimal(100, false)
}

var evalExp = Fn.new { |s|
    s = s.replace("abs-", "").replace("abs+", "").replace("abs", "")
    s = s.replace("*+", "*").replace("/+", "/")

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
    if (t.startsWith("--")) t = t[2..-1]
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
    var res = evalExp.call(t)
    if (!res.all{ |c| "0123456789.-+".contains(c)}) res = "0"
    return res
}

var checkForRepeats = Fn.new { |s|
    var d = s.split(".")
    if (d.count == 1 || d[1].count < 100) return s
    var t = d[1]
    var index = -1
    var res = s
    while (s.count > 1) {
        index = index + 1
        var outer1 = false
        for (i in 1 .. (s.count / 2).ceil) {
            var c = Str.chunks(t, i)
            var f = c[0]
            var outer2 = false
            var j = 1
            while (j < c.count - 2) {
                if (f != c[j]) {
                    outer2 = true
                    break
                }
                j = j + 1
            }
            if (outer2) continue
            if (f[0...c[-1].count] != c[-1]) break
            if (index < 99) {
                res = d[0] + "." + d[1][0...index] + "(" + f.join() + ")"
                if (res.endsWith(".(9)")) {
                    res = (BigInt.new(d[0]) + 1).toString
                }
            }
            outer1 = true
            break
        }
        if (outer1) break
        t = t[1..-1]
    }
    return res
}

var last = ""

while (true) {
    var s = Input.text("> ")
    if (s == "") return
    s = s.replace("@", last)
    last = evalArithmeticExp.call(s)
    if (!last.contains(".")) {
        System.print(last)
        continue
    }
    var display = checkForRepeats.call(last)
    if (!display.contains(")") && display.contains(".")) {
        display = BigRat.fromDecimal(last).round(50).toDecimal(50)
    }
    System.print(display)
}
