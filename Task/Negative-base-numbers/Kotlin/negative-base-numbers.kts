// version 1.1.2

const val DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

fun encodeNegBase(n: Long, b: Int): String {
    require(b in -62 .. -1)
    if (n == 0L) return "0"
    val out = mutableListOf<Char>()
    var nn = n
    while (nn != 0L) {
        var rem = (nn % b).toInt()
        nn /= b
        if (rem < 0) {
            nn++
            rem -= b
        }
        out.add(DIGITS[rem])
    }
    out.reverse()
    return out.joinToString("")
}

fun decodeNegBase(ns: String, b: Int): Long {
    require(b in -62 .. -1)
    if (ns == "0") return 0
    var total = 0L
    var bb = 1L
    for (c in ns.reversed()) {
        total += DIGITS.indexOf(c) * bb
        bb *= b
    }
    return total
}

fun main(args:Array<String>) {
    val nbl = listOf(10L to -2, 146L to -3, 15L to -10, -17596769891 to -62)
    for (p in nbl) {
        val ns = encodeNegBase(p.first, p.second)
        System.out.printf("%12d encoded in base %-3d = %s\n", p.first, p.second, ns)
        val n  = decodeNegBase(ns, p.second)
        System.out.printf("%12s decoded in base %-3d = %d\n\n", ns, p.second, n)
    }
}
