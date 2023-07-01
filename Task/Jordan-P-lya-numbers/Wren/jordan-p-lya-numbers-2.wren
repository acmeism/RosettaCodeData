import "./sort" for Find
import "./seq" for Lst
import "./fmt" for Fmt

var factorials = List.filled(19, 1)

var cacheFactorials = Fn.new {
    var fact = 1
    for (i in 2..18) {
        fact = fact * i
        factorials[i] = fact
    }
}

var JordanPolya = Fn.new { |limit|
    var ix = Find.nearest(factorials, limit).min(18)
    var res = factorials[0..ix]
    var k = 2
    while (k < res.count) {
        var rk = res[k]
        for (l in 2...res.count) {
            var kl = res[l] * rk
            if (kl > limit) break
            while (true) {
                var p = Find.nearest(res, kl)
                if (p < res.count && res[p] != kl) {
                    res.insert(p, kl)
                } else if (p == res.count) {
                    res.add(kl)
                }
                kl = kl * rk
                if (kl > limit) break
            }
        }
        k = k + 1
    }
    return res[1..-1]
}

var Decompose = Fn.new { |n, start|
    if (!start) start = 18
    if (start < 2) return []
    var m = n
    var f = []
    while (m % factorials[start] == 0) {
        f.add(start)
        m =  m / factorials[start]
        if (m == 1) return f
    }
    if (f.count > 0) {
        var g = Decompose.call(m, start-1)
        if (g.count > 0) {
            var prod = 1
            for (e in g) prod = prod * factorials[e]
            if (prod == m) return f + g
        }
    }
    return Decompose.call(n, start-1)
}

cacheFactorials.call()
var v = JordanPolya.call(2.pow(53)-1)
System.print("First 50 Jordan–Pólya numbers:")
Fmt.tprint("$4d ", v[0..49], 10)

System.write("\nThe largest Jordan–Pólya number before 100 million: ")
for (i in 1...v.count) {
    if (v[i] > 1e8) {
        Fmt.print("$,d\n", v[i-1])
        break
    }
}

for (i in [800, 1050, 1800, 2800, 3800]) {
    Fmt.print("The $,r Jordan-Pólya number is : $,d", i, v[i-1])
    var g = Lst.individuals(Decompose.call(v[i-1], null))
    var s = g.map { |l|
        if (l[1] == 1) return "%(l[0])!"
        return Fmt.swrite("($d!)$S", l[0], l[1])
    }.join(" x ")
    Fmt.print("= $s\n", s)
}
