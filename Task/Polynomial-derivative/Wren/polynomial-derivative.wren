var derivative = Fn.new { |p|
    if (p.count == 1) return [0]
    var d = p[1..-1].toList
    for (i in 0...d.count) d[i] = p[i+1] * (i + 1)
    return d
}

var ss = ["", "", "\u00b2", "\u00b3", "\u2074", "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"]

// for n <= 20
var superscript = Fn.new { |n| (n < 10) ? ss[n] : (n < 20) ? ss[1] + ss[n - 10] : ss[2] + ss[0] }

var polyPrint = Fn.new { |p|
    if (p.count == 1) return p[0].toString
    var terms = []
    for (i in 0...p.count) {
        if (p[i] == 0) continue
        var c = p[i].toString
        if (i > 0 && p[i].abs == 1) c = (p[i] == 1) ? "" : "-"
        var x = (i > 0) ? "x" : ""
        terms.add("%(c)%(x)%(superscript.call(i))")
    }
    return terms[-1..0].join("+").replace("+-", "-")
}

System.print("The derivatives of the following polynomials are:\n")
var polys = [ [5], [4, -3], [-1, 6, 5], [-4, 3, -2, 1], [1, 1, 0, -1, -1] ]
for (poly in polys) {
    var deriv = derivative.call(poly)
    System.print("%(poly) -> %(deriv)")
}
System.print("\nOr in normal mathematical notation:\n")
for (poly in polys) {
    var deriv = derivative.call(poly)
    System.print("Polynomial : %(polyPrint.call(poly))")
    System.print("Derivative : %(polyPrint.call(deriv))\n")
}
