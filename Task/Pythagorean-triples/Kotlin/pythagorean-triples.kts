// version 1.1.2

var total = 0L
var prim = 0L
var maxPeri = 0L

fun newTri(s0: Long, s1: Long, s2: Long) {
    val p = s0 + s1 + s2
    if (p <= maxPeri) {
        prim++
        total += maxPeri / p
        newTri( s0 - 2 * s1 + 2 * s2,  2 * s0 - s1 + 2 * s2,  2 * s0 - 2 * s1 + 3 * s2)
        newTri( s0 + 2 * s1 + 2 * s2,  2 * s0 + s1 + 2 * s2,  2 * s0 + 2 * s1 + 3 * s2)
        newTri(-s0 + 2 * s1 + 2 * s2, -2 * s0 + s1 + 2 * s2, -2 * s0 + 2 * s1 + 3 * s2)
    }
}

fun main(args: Array<String>) {
    maxPeri = 100
    while (maxPeri <= 10_000_000_000L) {
        prim = 0
        total = 0
        newTri(3, 4, 5)
        println("Up to $maxPeri: $total triples, $prim primatives")
        maxPeri *= 10
    }
}
