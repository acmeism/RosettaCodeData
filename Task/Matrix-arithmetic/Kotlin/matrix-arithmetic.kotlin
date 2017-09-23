// version 1.1.2

typealias Matrix = Array<DoubleArray>

fun johnsonTrotter(n: Int): Pair<List<IntArray>, List<Int>> {
    val p = IntArray(n) { it }  // permutation
    val q = IntArray(n) { it }  // inverse permutation
    val d = IntArray(n) { -1 }  // direction = 1 or -1
    var sign = 1
    val perms = mutableListOf<IntArray>()
    val signs = mutableListOf<Int>()

    fun permute(k: Int) {
        if (k >= n) {
            perms.add(p.copyOf())
            signs.add(sign)
            sign *= -1
            return
        }
        permute(k + 1)
        for (i in 0 until k) {
            val z = p[q[k] + d[k]]
            p[q[k]] = z
            p[q[k] + d[k]] = k
            q[z] = q[k]
            q[k] += d[k]
            permute(k + 1)
        }
        d[k] *= -1
    }

    permute(0)
    return perms to signs
}

fun determinant(m: Matrix): Double {
    val (sigmas, signs) = johnsonTrotter(m.size)
    var sum = 0.0
    for ((i, sigma) in sigmas.withIndex()) {
        var prod = 1.0
        for ((j, s) in sigma.withIndex()) prod *= m[j][s]
        sum += signs[i] * prod
    }
    return sum
}

fun permanent(m: Matrix) : Double {
    val (sigmas, _) = johnsonTrotter(m.size)
    var sum = 0.0
    for (sigma in sigmas) {
        var prod = 1.0
        for ((i, s) in sigma.withIndex()) prod *= m[i][s]
        sum += prod
    }
    return sum
}

fun main(args: Array<String>) {
    val m1 = arrayOf(
        doubleArrayOf(1.0)
    )

    val m2 = arrayOf(
        doubleArrayOf(1.0, 2.0),
        doubleArrayOf(3.0, 4.0)
    )

    val m3 = arrayOf(
        doubleArrayOf(2.0, 9.0, 4.0),
        doubleArrayOf(7.0, 5.0, 3.0),
        doubleArrayOf(6.0, 1.0, 8.0)
    )

    val m4 = arrayOf(
        doubleArrayOf( 1.0,  2.0,  3.0,  4.0),
        doubleArrayOf( 4.0,  5.0,  6.0,  7.0),
        doubleArrayOf( 7.0,  8.0,  9.0, 10.0),
        doubleArrayOf(10.0, 11.0, 12.0, 13.0)
    )

    val matrices = arrayOf(m1, m2, m3, m4)
    for (m in matrices) {
        println("m${m.size} -> ")
        println("  determinant = ${determinant(m)}")
        println("  permanent   = ${permanent(m)}\n")
    }
}
