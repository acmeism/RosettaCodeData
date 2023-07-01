import "/long" for ULong

var Nr = [3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3]
var Nc = [3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2]
var n  = 0
var n1 = 0
var N0 = List.filled(85, 0)
var N2 = List.filled(85, 0)
var N3 = List.filled(85, 0)
var N4 = List.filled(85, 0)
var i  = 1
var g  = 8
var e  = 2
var l  = 4

var fN  // forward declaration

var xx = ULong.fromBaseString("123456789abcdef0", 16)
var fifteen = ULong.new(15)

var fY = Fn.new {
    if (N2[n] == xx ) return true
    if (N4[n] <= n1) return fN.call()
    return false
}

var fI = Fn.new {
    var g = (11 - N0[n]) * 4
    var a = N2[n] & (fifteen << g)
    N0[n+1] = N0[n] + 4
    N2[n+1] = N2[n] - a + (a << 16)
    N3[n+1] = "d"
    N4[n+1] = N4[n]
    var cond = Nr[(a >> g).toSmall] <= (N0[n] >> 2)
    if (!cond) N4[n+1] = N4[n+1] + 1
    n = n + 1
}

var fG = Fn.new {
    var g = (19 - N0[n]) * 4
    var a = N2[n] & (fifteen << g)
    N0[n+1] = N0[n] - 4
    N2[n+1] = N2[n] - a + (a >> 16)
    N3[n+1] = "u"
    N4[n+1] = N4[n]
    var cond = Nr[(a >> g).toSmall] >= (N0[n] >> 2)
    if (!cond) N4[n+1] = N4[n+1] + 1
    n = n + 1
}

var fE = Fn.new {
    var g = (14 - N0[n]) * 4
    var a = N2[n] & (fifteen << g)
    N0[n+1] = N0[n] + 1
    N2[n+1] = N2[n] - a + (a << 4)
    N3[n+1] = "r"
    N4[n+1] = N4[n]
    var cond = Nc[(a >> g).toSmall] <= N0[n] % 4
    if (!cond) N4[n+1] = N4[n+1] + 1
    n = n + 1
}

var fL = Fn.new {
    var g = (16 - N0[n]) * 4
    var a = N2[n] & (fifteen << g)
    N0[n+1] = N0[n] - 1
    N2[n+1] = N2[n] - a + (a >> 4)
    N3[n+1] = "l"
    N4[n+1] = N4[n]
    var cond = Nc[(a >> g).toSmall] >= N0[n] % 4
    if (!cond) N4[n+1] = N4[n+1] + 1
    n = n + 1
}

var fZ = Fn.new { |w|
    if (w&i > 0) {
        fI.call()
        if (fY.call()) return true
        n = n - 1
    }
    if (w&g > 0) {
        fG.call()
        if (fY.call()) return true
        n = n - 1
    }
    if (w&e > 0) {
        fE.call()
        if (fY.call()) return true
        n = n - 1
    }
    if (w&l > 0) {
        fL.call()
        if (fY.call()) return true
        n = n - 1
    }
    return false
}

fN = Fn.new {
    var p0 = N0[n]
    if (p0 == 0) {
        var p3 = N3[n]
        if (p3 == "l") return fZ.call(i)
        if (p3 == "u") return fZ.call(e)
        return fZ.call(i + e)
    } else if (p0 == 3) {
        var p3 = N3[n]
        if (p3 == "r") return fZ.call(i)
        if (p3 == "u") return fZ.call(l)
        return fZ.call(i + l)
    } else if (p0 == 1 || p0 == 2) {
        var p3 = N3[n]
        if (p3 == "l") return fZ.call(i + l)
        if (p3 == "r") return fZ.call(i + e)
        if (p3 == "u") return fZ.call(e + l)
        return fZ.call(l + e + i)
    } else if (p0 == 12) {
        var p3 = N3[n]
        if (p3 == "l") return fZ.call(g)
        if (p3 == "d") return fZ.call(e)
        return fZ.call(e + g)
    } else if (p0 == 15) {
        var p3 = N3[n]
        if (p3 == "r") return fZ.call(g)
        if (p3 == "d") return fZ.call(l)
        return fZ.call(g + l)
    } else if (p0 == 13 || p0 == 14) {
        var p3 = N3[n]
        if (p3 == "l") return fZ.call(g + l)
        if (p3 == "r") return fZ.call(e + g)
        if (p3 == "d") return fZ.call(e + l)
        return fZ.call(g + e + l)
    } else if (p0 == 4 || p0 == 8) {
        var p3 = N3[n]
        if (p3 == "l") return fZ.call(i + g)
        if (p3 == "u") return fZ.call(g + e)
        if (p3 == "d") return fZ.call(i + e)
        return fZ.call(i + g + e)
    } else if (p0 == 7 || p0 == 11) {
        var p3 = N3[n]
        if (p3 == "d") return fZ.call(i + l)
        if (p3 == "u") return fZ.call(g + l)
        if (p3 == "r") return fZ.call(i + g)
        return fZ.call(i + g + l)
    } else {
        var p3 = N3[n]
        if (p3 == "d") return fZ.call(i + e + l)
        if (p3 == "l") return fZ.call(i + g + l)
        if (p3 == "r") return fZ.call(i + g + e)
        if (p3 == "u") return fZ.call(g + e + l)
        return fZ.call(i + g + e + l)
    }
}

var fifteenSolver = Fn.new { |n, g|
    N0[0] = n
    N2[0] = g
    N4[0] = 0
}

var solve // recursive function
solve = Fn.new {
    if (fN.call()) {
        System.print("Solution found in %(n) moves: ")
        for (g in 1..n) System.write(N3[g])
        System.print()
    } else {
        n = 0
        n1 = n1 + 1
        solve.call()
    }
}

fifteenSolver.call(8, ULong.fromBaseString("fe169b4c0a73d852", 16))
solve.call()
