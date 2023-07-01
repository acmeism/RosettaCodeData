import "/fmt" for Fmt
import "/sort" for Sort

var fairshare = Fn.new { |n, base|
    var res = List.filled(n, 0)
    for (i in 0...n) {
        var j = i
        var sum = 0
        while (j > 0) {
            sum = sum + (j%base)
            j = (j/base).floor
        }
        res[i] = sum % base
    }
    return res
}

var turns = Fn.new { |n, fss|
    var m = {}
    for (fs in fss) {
        var k = m[fs]
        if (!k) {
            m[fs] = 1
        } else {
            m[fs] = k + 1
        }
    }
    var m2 = {}
    for (k in m.keys) {
        var v = m[k]
        var k2 = m2[v]
        if (!k2) {
            m2[v] = 1
        } else {
            m2[v] = k2 + 1
        }
    }
    var res = []
    var sum = 0
    for (k in m2.keys) {
        var v = m2[k]
        sum = sum + v
        res.add(k)
    }
    if (sum != n) return "only %(sum) have a turn"
    Sort.quick(res)
    var res2 = List.filled(res.count, "")
    for (i in 0...res.count) res2[i] = res[i].toString
    return res2.join(" or ")
}

for (base in [2, 3, 5, 11]) {
    Fmt.print("$2d : $2d", base, fairshare.call(25, base))
}
System.print("\nHow many times does each get a turn in 50,000 iterations?")
for (base in [191, 1377, 49999, 50000, 50001]) {
    var t = turns.call(base, fairshare.call(50000, base))
    Fmt.print("  With $5d people: $s", base, t)
}
