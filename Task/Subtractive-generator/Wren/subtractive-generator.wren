var mod = 1e9
var state = List.filled(55, 0)
var si = 0
var sj = 0

var subrand // forward declaration

var subrandSeed = Fn.new { |p|
    var p2 = 1
    state[0] = p % mod
    var j = 21
    for (i in 1..54) {
        if (j >= 55) j = j - 55
        state[j] = p2
        p2 = p - p2
        if (p2 < 0) p2 = p2 + mod
        p = state[j]
        j = j + 21
    }
    si = 0
    sj = 24
    for (i in 1..165) subrand.call()
}

subrand = Fn.new {
    if (si == sj) subrandSeed.call(0)
    si = (si == 0) ? 54 : si - 1
    sj = (sj == 0) ? 54 : sj - 1
    var x = state[si] - state[sj]
    if (x < 0) x = x + mod
    state[si] = x
    return x
}

subrandSeed.call(292929)
for (i in 0..9) System.print("r[%(i+220)] = %(subrand.call())")
