import "/big" for BigRat
import "/fmt" for Fmt

var p = { 1: 0 }
var lvl = [[1]]

var path // recursive
path = Fn.new { |n|
    if (n == 0) return []
    while (!p.containsKey(n)) {
        var q = []
        for (x in lvl[0]) {
            System.write("") // guard against VM recursion bug
            for (y in path.call(x)) {
                if (p.containsKey(x + y)) break
                p[x + y] = x
                q.add(x + y)
            }
        }
        lvl[0] = q
    }
    System.write("") // guard against VM recursion bug
    var l = path.call(p[n])
    l.add(n)
    return l
}

var treePow = Fn.new { |x, n|
    var r = { 0: BigRat.one, 1: BigRat.fromDecimal(x) }
    var p = 0
    for (i in path.call(n)) {
        r[i] = r[i-p] * r[p]
        p = i
    }
    return r[n]
}

var showPow = Fn.new { |x, n|
    System.print("%(n): %(path.call(n))")
    Fmt.print("$s ^ $d = $s\n", x, n, treePow.call(x, n).toDecimal(6))
}

for (n in 0..17) showPow.call(2, n)
showPow.call(1.1, 81)
showPow.call(3, 191)
