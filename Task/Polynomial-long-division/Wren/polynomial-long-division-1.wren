import "/dynamic" for Tuple

var Solution = Tuple.create("Solution", ["quotient", "remainder"])

var polyDegree = Fn.new { |p|
    for (i in p.count-1..0) if (p[i] != 0) return i
    return -2.pow(31)
}

var polyShiftRight = Fn.new { |p, places|
    if (places <= 0) return p
    var pd = polyDegree.call(p)
    if (pd + places >= p.count) {
        Fiber.abort("The number of places to be shifted is too large.")
    }
    var d = p.toList
    for (i in pd..0) {
        d[i + places] = d[i]
        d[i] = 0
    }
    return d
}

var polyMultiply = Fn.new { |p, m|
    for (i in 0...p.count) p[i] = p[i] * m
}

var polySubtract = Fn.new { |p, s|
    for (i in 0...p.count) p[i] = p[i] - s[i]
}

var polyLongDiv = Fn.new { |n, d|
    if (n.count != d.count) {
        Fiber.abort("Numerator and denominator vectors must have the same size")
    }
    var nd = polyDegree.call(n)
    var dd = polyDegree.call(d)
    if (dd < 0) {
        Fiber.abort("Divisor must have at least one one-zero coefficient")
    }
    if (nd < dd) {
        Fiber.abort("The degree of the divisor cannot exceed that of the numerator")
    }
    var n2 = n.toList
    var q = List.filled(n.count, 0)
    while (nd >= dd) {
        var d2 = polyShiftRight.call(d, nd - dd)
        q[nd - dd] = n2[nd] / d2[nd]
        polyMultiply.call(d2, q[nd - dd])
        polySubtract.call(n2, d2)
        nd = polyDegree.call(n2)
    }
    return Solution.new(q, n2)
}

var polyShow = Fn.new { |p|
    var pd = polyDegree.call(p)
    for (i in pd..0) {
        var coeff = p[i]
        if (coeff != 0) {
            System.write(
                (coeff ==  1) ? ((i < pd) ? " + " :  "") :
                (coeff == -1) ? ((i < pd) ? " - " : "-") :
                (coeff <   0) ? ((i < pd) ? " - %(-coeff)" : "%(coeff)") :
                                ((i < pd) ? " + %( coeff)" : "%(coeff)")
            )
            if (i > 1) {
                System.write("x^%(i)")
            } else if (i == 1) {
                System.write("x")
            }
        }
    }
    System.print()
}

var n = [-42, 0, -12, 1]
var d = [ -3, 1,   0, 0]
System.write("Numerator   : ")
polyShow.call(n)
System.write("Denominator : ")
polyShow.call(d)
System.print("-------------------------------------")
var sol = polyLongDiv.call(n, d)
System.write("Quotient    : ")
polyShow.call(sol.quotient)
System.write("Remainder   : ")
polyShow.call(sol.remainder)
