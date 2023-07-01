// version 1.1.51

const val MOD = 1_000_000_000

val state = IntArray(55)
var si = 0
var sj = 0

fun subrandSeed(p: Int) {
    var p1 = p
    var p2 = 1
    state[0] = p1 % MOD
    var j = 21
    for (i in 1..54) {
        if (j >=55) j -= 55
        state[j] = p2
        p2 = p1 - p2
        if (p2 < 0) p2 += MOD
        p1 = state[j]
        j += 21
    }
    si = 0
    sj = 24
    repeat(165) { subrand() }
}

fun subrand(): Int {
    if (si == sj) subrandSeed(0)
    if (si-- == 0) si = 54
    if (sj-- == 0) sj = 54
    var x = state[si] - state[sj]
    if (x < 0) x += MOD
    state[si] = x
    return x
}

fun main(args: Array<String>) {
    subrandSeed(292_929)
    for (i in 0..9) println("r[${i + 220}] = ${subrand()}")
}
