// version 1.1.2

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

fun printPermsAndSigns(perms: List<IntArray>, signs: List<Int>) {
    for ((i, perm) in perms.withIndex()) {
        println("${perm.contentToString()} -> sign = ${signs[i]}")
    }
}

fun main(args: Array<String>) {
    val (perms, signs) = johnsonTrotter(3)
    printPermsAndSigns(perms, signs)
    println()
    val (perms2, signs2) = johnsonTrotter(4)
    printPermsAndSigns(perms2, signs2)
}
