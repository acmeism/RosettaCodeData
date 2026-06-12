import "./math" for Math, Int, Nums
import "./fmt" for Fmt

var valp = Fn.new { |n, p|
    var s = 0
    while (n != 0) {
        n = Int.div(n, p)
        s = s + n
    }
    return s
}

var K = Fn.new { |p, e|
    if (e <= p) return e * p
    var t = Int.div(e * (p - 1), p) * p
    while (valp.call(t, p) < e) t = t + p
    return t
}

var kempner = Fn.new { |n|
    if (n == 1) return 1
    var items = []
    for (pe in Int.primePowers(n)) items.add(K.call(pe[0], pe[1]))
    return Nums.max(items)
}

System.print("The first 50 Kempner numbers are:")
for (n in 1..50) {
    Fmt.write("$2d  ", kempner.call(n))
    if (n % 10 == 0) System.print()
}

System.print("\nKempner numbers for the range 77135679311 to 77135679321:")
for (n in 77135679311..77135679321) {
    Fmt.print("S($d) = $,14d", n, kempner.call(n))
}
