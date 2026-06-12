import "./pattern" for Pattern

var powers = [
    ["0", "⁰"],
    ["1", "¹"],
    ["2", "²"],
    ["3", "³"],
    ["4", "⁴"],
    ["5", "⁵"],
    ["6", "⁶"],
    ["7", "⁷"],
    ["8", "⁸"],
    ["9", "⁹"],
    ["-", "⁻"]
]

var fractions = [
    [".25", "¼"],
    [".5", "½"],
    [".75", "¾"],
    [".14285714285714", "⅐"],
    [".11111111111111", "⅑"],
    [".1", "⅒"],
    [".33333333333333", "⅓"],
    [".66666666666667", "⅔"],
    [".2", "⅕"],
    [".4", "⅖"],
    [".6", "⅗"],
    [".8", "⅘"],
    [".16666666666667", "⅙"],
    [".83333333333333", "⅚"],
    [".125", "⅛"],
    [".375", "⅜"],
    [".625", "⅝"],
    [".875", "⅞"]
]

var printEquation = Fn.new { |coefs|
    System.write("=> ")
    if (coefs.isEmpty) {
        System.print("0\n")
        return
    }
    var keys = coefs.keys.toList
    var max = keys[0]
    var min = keys[0]
    for (k in keys.skip(1)) {
        if (k > max) max = k
        if (k < min) min = k
    }
    for (p in max..min) {
        var c = coefs[p] ? coefs[p] : 0
        if (c != 0) {
            if (p < max) {
                var sign = "+"
                if (c < 0) {
                    sign = "-"
                    c = -c
                }
                System.write(" %(sign) ")
            }
            if (c != 1 || (c == 1 && p == 0)) {
                var cs = c.toString
                var ix = cs.indexOf(".")
                if (ix >= 0) {
                    var dec = cs[ix..-1]
                    for (frac in fractions) {
                        if (dec == frac[0]) {
                            cs = cs[0...ix] + frac[1]
                            break
                        }
                    }
                }
                if (cs[0] == "0" && cs.count > 1 && cs[1] != ".") cs = cs[1..-1]
                System.write(cs)
            }
            if (p != 0) {
                var ps = p.toString
                for (power in powers) ps = ps.replace(power[0], power[1])
                if (ps == "¹") ps = ""
                System.write("x%(ps)")
            }
        }
    }
    System.print("\n")
}

var equs = [
    "-0.00x⁺¹⁰ + 1.0·x ** 5 + -2e0x^4 + +0,042.00 × x ⁺³ + +.0x² + 20.000 000 000x¹ - -1x⁺⁰ + .0x⁻¹ + 20.x¹",
    "x⁵ - 2x⁴ + 42x³ + 0x² + 40x + 1",
    "0e+0x⁰⁰⁷ + 00e-00x + 0x + .0x⁰⁵ - 0.x⁴ + 0×x³ + 0x⁻⁰ + 0/x + 0/x³ + 0x⁻⁵",
    "1x⁵ - 2x⁴ + 42x³ + 40x + 1x⁰",
    "+x⁺⁵ + -2x⁻⁻⁴ + 42x⁺⁺³ + +40x - -1",
    "x^5 - 2x**4 + 42x^3 + 40x + 1",
    "x↑5 - 2.00·x⁴ + 42.00·x³ + 40.00·x + 1",
    "x⁻⁵ - 2⁄x⁴ + 42x⁻³ + 40/x + 1x⁻⁰",
    "x⁵ - 2x⁴ + 42.000 000x³ + 40x + 1",
    "x⁵ - 2x⁴ + 0,042x³ + 40.000,000x + 1",
    "0x⁷ + 10x + 10x + x⁵ - 2x⁴ + 42x³ + 20x + 1",
    "1E0x⁵ - 2,000,000.e-6x⁴ + 4.2⏨1x³ + .40e+2x + 1",
    "x⁵ - x⁴⁄2 + 405x³⁄4 + 403x⁄4 + 5⁄2",
    "x⁵ - 0.5x⁴ + 101.25x³ + 100.75x + 2.5",
    "x⁻⁵ - 2⁄x⁴ + 42x⁻³ - 40/x",
    "⅐x⁵ - ⅓x⁴ - ⅔x⁴ + 42⅕x³ + ⅑x - 40⅛ - ⅝"
]

var pattern = Pattern.new("+1/s/n+1/s")

var reps = [
    [",", ""],
    [" ", ""],
    ["¼", ".25"],
    ["½", ".5"],
    ["¾", ".75"],
    ["⅐", ".14285714285714"],
    ["⅑", ".11111111111111"],
    ["⅒", ".1"],
    ["⅓", ".33333333333333"],
    ["⅔", ".66666666666667"],
    ["⅕", ".2"],
    ["⅖", ".4"],
    ["⅗", ".6"],
    ["⅘", ".8"],
    ["⅙", ".16666666666667"],
    ["⅚", ".83333333333333"],
    ["⅛", ".125"],
    ["⅜", ".375"],
    ["⅝", ".625"],
    ["⅞", ".875"],
    ["↉", ".0"],
    ["⏨", "e"],
    ["⁄", "/"]
]

var reps2 = [
    ["⁰", "0"],
    ["¹", "1"],
    ["²", "2"],
    ["³", "3"],
    ["⁴", "4"],
    ["⁵", "5"],
    ["⁶", "6"],
    ["⁷", "7"],
    ["⁸", "8"],
    ["⁹", "9"],
    ["⁻⁻", ""],
    ["⁻", "-"],
    ["⁺", ""],
    ["**", ""],
    ["^", ""],
    ["↑", ""],
    ["⁄", "/"]
]

for (equ in equs) {
    System.print(equ)
    var terms = pattern.splitAll(equ)
    var ops = pattern.findAll(equ).map { |m| m.text.trim() }.toList
    var coefs = {}
    var i = 0
    for (term in terms) {
        var s = term.split("x")
        var t = s[0].trimEnd("·× ")
        for (rep in reps) t = t.replace(rep[0], rep[1])
        var c = 1
        var inverse = false
        if (t == "" || t == "+" || t == "-") t = t + "1"
        var ix = t.indexOf("/")
        if (ix == t.count - 1) {
            inverse = true
            t = t[0..-2]
            c = Num.fromString(t)
        } else if (ix >= 0) {
            var u = t.split("/")
            var m = Num.fromString(u[0])
            var n = Num.fromString(u[1])
            c = m / n
        } else {
            c = Num.fromString(t)
        }
        if (i > 0 && ops[i-1] == "-") c = -c
        if (c == -0) c = 0
        var cont = false
        if (s.count == 1) {
            coefs[0] = coefs[0] ? coefs[0] + c : c
            cont = true
        }
        if (!cont) {
            var u = s[1].trim()
            if (u == "") {
                var p = 1
                if (inverse) p = -1
                if (c != 0) coefs[p] = coefs[p] ? coefs[p] + c : c
                cont = true
            }
            if (!cont) {
                for (rep in reps2) u = u.replace(rep[0], rep[1])
                var jx = u.indexOf("/")
                var p = 1
                if (jx >= 0) {
                    var v = u.split("/")
                    p = Num.fromString(v[0])
                    if (p == null) p = 1
                    var d = Num.fromString(v[1])
                    c = c / d
                } else {
                    p = Num.fromString(u.trim())
                    if (p == null) p = 1
                }
                if (inverse) p = -p
                if (c != 0) coefs[p] = coefs[p] ? coefs[p] + c : c
            }
        }
        i = i + 1
    }
    printEquation.call(coefs)
}
