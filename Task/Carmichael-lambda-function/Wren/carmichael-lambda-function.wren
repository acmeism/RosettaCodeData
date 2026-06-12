import "./math" for Int
import "./fmt" for Fmt

var primePows = Fn.new { |n|
    var factPows = []
    var pf = Int.primeFactors(n)
    var currFact = pf[0]
    var count = 1
    for (fact in pf.skip(1)) {
        if (fact != currFact) {
            factPows.add([currFact, count])
            currFact = fact
            count = 1
        } else {
            count = count + 1
        }
    }
    factPows.add([currFact, count])
    return factPows
}

var phi = Fn.new { |p, r| p.pow(r-1) * (p - 1) }

var cache = { 1: 1, 2: phi.call(2, 1), 4: phi.call(2, 2) }

var CarmichaelHelper = Fn.new { |p, r|
    var n = p.pow(r)
    if (cache.containsKey(n)) return cache[n]
    if (p > 2) return cache[n] = phi.call(p, r)
    return cache[n] = phi.call(p, r - 1)
}

var CarmichaelLambda = Fn.new { |n|
    if (n < 1) Fiber.abort("'n' must be a positive integer.")
    if (cache.containsKey(n)) return cache[n]
    var pps = primePows.call(n)
    if (pps.count == 1) {
        var p = pps[0][0]
        var r = pps[0][1]
        if (p > 2) return cache[n] = phi.call(p, r)
        return cache[n] = phi.call(p, r - 1)
    }
    var a = []
    for (pp in pps) a.add(CarmichaelHelper.call(pp[0], pp[1]))
    return cache[n] = Int.lcm(a)
}

var iteratedToOne = Fn.new { |i|
    var k = 0
    while (i > 1) {
        i = CarmichaelLambda.call(i)
        k = k + 1
    }
    return k
}

System.print(" n   λ   k")
System.print("----------")
for (n in 1..25) {
    var lambda = CarmichaelLambda.call(n)
    var k = iteratedToOne.call(n)
    Fmt.print("$2d  $2d  $2d", n, lambda, k)
}

System.print("\nIterations to 1       i     lambda(i)")
System.print("=====================================")
System.print("   0                  1            1")
var maxI = 5 * 1e6
var maxN = 15
var found = List.filled(maxN + 1, false)
found[0] = true
var i = 1
while (i <= maxI) {
    var n = iteratedToOne.call(i)
    if (!found[n]) {
        found[n] = true
        var lambda = CarmichaelLambda.call(i)
        Fmt.print("$4d $,18d $,12d", n, i, lambda)
        if (n == maxN) break
    }
    i = i + 1
}
