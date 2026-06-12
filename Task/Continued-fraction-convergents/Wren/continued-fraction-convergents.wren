import "./rat" for Rat

var cfcRat = Fn.new { |m, n|
    var p = [0, 1]
    var q = [1, 0]
    var s = []
    var r = Rat.new(m, n)
    var rem = r
    while (true) {
        var whole = rem.truncate
        var frac  = rem.fraction
        var pn = whole * p[-1] + p[-2]
        var qn = whole * q[-1] + q[-2]
        var sn = pn / qn
        p.add(pn)
        q.add(qn)
        s.add(sn)
        if (r == sn) break
        rem = frac.inverse
    }
    return s
}

var cfcQuad = Fn.new { |a, b, m, n, k|
    var p = [0, 1]
    var q = [1, 0]
    var s = []
    var rem = (a.sqrt * b + m) / n
    for (i in 1..k) {
        var whole = rem.truncate
        var frac  = rem.fraction
        var pn = whole * p[-1] + p[-2]
        var qn = whole * q[-1] + q[-2]
        var sn = Rat.new(pn, qn)
        p.add(pn)
        q.add(qn)
        s.add(sn)
        rem = 1 / frac
    }
    return s
}

System.print("The continued fraction convergents for the following (maximum 8 terms) are:")
System.print("415/93  = %(cfcRat.call(415, 93))")
System.print("649/200 = %(cfcRat.call(649, 200))")
System.print("√2      = %(cfcQuad.call(2, 1, 0, 1, 8))")
System.print("√5      = %(cfcQuad.call(5, 1, 0, 1, 8))")
System.print("phi     = %(cfcQuad.call(5, 1, 1, 2, 8))")
