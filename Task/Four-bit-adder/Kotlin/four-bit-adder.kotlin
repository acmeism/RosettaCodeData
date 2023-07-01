// version 1.1.51

val Boolean.I get() = if (this) 1 else 0

val Int.B get() = this != 0

class Nybble(val n3: Boolean, val n2: Boolean, val n1: Boolean, val n0: Boolean) {
    fun toInt() = n0.I + n1.I * 2 + n2.I * 4 + n3.I * 8

    override fun toString() = "${n3.I}${n2.I}${n1.I}${n0.I}"
}

fun Int.toNybble(): Nybble {
    val n = BooleanArray(4)
    for (k in 0..3) n[k] = ((this shr k) and 1).B
    return Nybble(n[3], n[2], n[1], n[0])
}

fun xorGate(a: Boolean, b: Boolean) = (a && !b) || (!a && b)

fun halfAdder(a: Boolean, b: Boolean) = Pair(xorGate(a, b), a && b)

fun fullAdder(a: Boolean, b: Boolean, c: Boolean): Pair<Boolean, Boolean> {
    val (s1, c1) = halfAdder(c, a)
    val (s2, c2) = halfAdder(s1, b)
    return s2 to (c1 || c2)
}

fun fourBitAdder(a: Nybble, b: Nybble): Pair<Nybble, Int> {
    val (s0, c0) = fullAdder(a.n0, b.n0, false)
    val (s1, c1) = fullAdder(a.n1, b.n1, c0)
    val (s2, c2) = fullAdder(a.n2, b.n2, c1)
    val (s3, c3) = fullAdder(a.n3, b.n3, c2)
    return Nybble(s3, s2, s1, s0) to c3.I
}

const val f = "%s + %s = %d %s (%2d + %2d = %2d)"

fun test(i: Int, j: Int) {
    val a = i.toNybble()
    val b = j.toNybble()
    val (r, c) = fourBitAdder(a, b)
    val s = c * 16 + r.toInt()
    println(f.format(a, b, c, r, i, j, s))
}

fun main(args: Array<String>) {
    println(" A      B     C  R     I    J    S")
    for (i in 0..15) {
        for (j in i..minOf(i + 1, 15)) test(i, j)
    }
}
