import "/dynamic" for Enum
import "/fmt" for Fmt
import "/seq" for Lst
import "/math" for Nums
import "/sort" for Sort

var Direction = Enum.create("Direction", ["UP", "DOWN"])

// test also for 'Unknown' correction type
var types = [
    "Benjamini-Hochberg", "Benjamini-Yekutieli", "Bonferroni", "Hochberg",
    "Holm", "Hommel", "Šidák", "Unknown"
]

var pFormat = Fn.new { |p, cols|
    var i = -cols
    var fmt = "$1.10f"
    return Lst.chunks(p, cols).map { |chunk|
        i = i + cols
        return Fmt.swrite("[$2d  $s", i, chunk.map { |v| Fmt.swrite(fmt, v) }.join(" "))
    }.join("\n")
}

var check = Fn.new { |p|
    if (p.count == 0 || Nums.min(p) < 0 || Nums.max(p) > 1) {
        Fiber.abort("p-values must be in range 0 to 1")
    }
    return p
}

var ratchet = Fn.new { |p, dir|
    var pp = p.toList
    var m = pp[0]
    if (dir == Direction.UP) {
        for (i in 1...pp.count) {
            if (pp[i] > m) pp[i] = m
            m = pp[i]
        }
    } else {
        for (i in 1...pp.count) {
            if (pp[i] < m) pp[i] = m
            m = pp[i]
        }
    }
    return pp.map { |v| (v < 1) ? v : 1 }.toList
}

var schwartzian = Fn.new { |p, mult, dir|
    var size = p.count
    var pwi = List.filled(size, null)
    for (i in 0...size) pwi[i] = [i, p[i]]
    var cmp = (dir == Direction.UP) ? Fn.new { |a, b| (b[1] - a[1]).sign } :
                                      Fn.new { |a, b| (a[1] - b[1]).sign }
    var order = Sort.merge(pwi, cmp).map { |e| e[0] }.toList
    var pa = List.filled(size, 0)
    for (i in 0...size) pa[i] = mult[i] * p[order[i]]
    pa = ratchet.call(pa, dir)
    var owi = List.filled(order.count, null)
    for (i in 0...order.count) owi[i] = [i, order[i]]
    cmp = Fn.new { |a, b| (a[1] - b[1]).sign }
    var order2 = Sort.merge(owi, cmp).map { |e| e[0] }.toList
    var res = List.filled(size, 0)
    for (i in 0...size) res[i] = pa[order2[i]]
    return res
}

var adjust = Fn.new { |p, type|
    var size = p.count
    if (size == 0) Fiber.abort("List cannot be empty.")
    if (type == "Benjamini-Hochberg") {
        var mult = List.filled(size, 0)
        for (i in 0...size) mult[i] = size / (size - i)
        return schwartzian.call(p, mult, Direction.UP)

    } else if (type == "Benjamini-Yekutieli") {
        var q = (1..size).reduce { |acc, i| acc + 1/i }
        var mult = List.filled(size, 0)
        for (i in 0...size) mult[i] = q * size / (size - i)
        return schwartzian.call(p, mult, Direction.UP)

    } else if (type == "Bonferroni") {
        return p.map { |v| (v * size).min(1) }.toList

    } else if (type == "Hochberg") {
        var mult = List.filled(size, 0)
        for (i in 0...size) mult[i] = i + 1
        return schwartzian.call(p, mult, Direction.UP)

    } else if (type == "Holm") {
        var mult = List.filled(size, 0)
        for (i in 0...size) mult[i] = size - i
        return schwartzian.call(p, mult, Direction.DOWN)

    } else if (type == "Hommel") {
        var pwi = List.filled(size, null)
        for (i in 0...size) pwi[i] = [i, p[i]]
        var cmp = Fn.new { |a, b| (a[1] - b[1]).sign }
        var order = Sort.merge(pwi, cmp).map { |e| e[0] }.toList
        var s = List.filled(size, 0)
        for (i in 0...size) s[i] = p[order[i]]
        var m = List.filled(size, 0)
        for (i in 0...size) m[i] = s[i] * size / (i + 1)
        var min = Nums.min(m)
        var q = List.filled(size, min)
        var pa = List.filled(size, min)
        for (j in size-1..2) {
            var lower = List.filled(size - j + 1, 0)                // lower indices
            for (i in 0...lower.count) lower[i] = i
            var upper = List.filled(j - 1, 0)                       // upper indices
            for (i in 0...upper.count) upper[i] = size - j + 1 + i
            var qmin = j * s[upper[0]] / 2
            for (i in 1...upper.count) {
                var temp = s[upper[i]] * j / (2 + i)
                if (temp < qmin) qmin = temp
            }
            for (i in 0...lower.count) {
                q[lower[i]] = qmin.min(s[lower[i]] * j)
            }
            for (i in 0...upper.count) q[upper[i]] = q[size - j]
            for (i in 0...size) if (pa[i] < q[i]) pa[i] = q[i]
        }
        var owi = List.filled(order.count, null)
        for (i in 0...order.count) owi[i] = [i, order[i]]
        var order2 = Sort.merge(owi, cmp).map { |e| e[0] }.toList
        var res = List.filled(size, 0)
        for (i in 0...size) res[i] = pa[order2[i]]
        return res

    } else if (type == "Šidák") {
        return p.map { |v| 1 - (1 - v).pow(size) }.toList

    } else {
        System.print("\nSorry, do not know how to do '%(type)' correction.\n" +
                     "Perhaps you want one of these?:\n" +
                     types[0...-1].map { |t| "  %(t)" }.join("\n")
        )
        Fiber.suspend()
    }
}

var adjusted = Fn.new { |p, type| "\n%(type)\n%(pFormat.call(adjust.call(check.call(p), type), 5))" }

var pValues = [
    4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
    8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
    4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
    8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
    3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
    1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
    4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
    3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
    1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
    2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
]
types.each { |type| System.print(adjusted.call(pValues, type)) }
