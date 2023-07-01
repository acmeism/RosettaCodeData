// version 1.1.2

const val LIMIT = 1_000_000

val sb = StringBuilder()

fun selfRefSeq(s: String): String {
    sb.setLength(0)  // faster than using a local StringBuilder object
    for (d in '9' downTo '0') {
        if (d !in s) continue
        val count = s.count { it == d }
        sb.append("$count$d")
    }
    return sb.toString()
}

fun permute(input: List<Char>): List<List<Char>> {
    if (input.size == 1) return listOf(input)
    val perms = mutableListOf<List<Char>>()
    val toInsert = input[0]
    for (perm in permute(input.drop(1))) {
        for (i in 0..perm.size) {
            val newPerm = perm.toMutableList()
            newPerm.add(i, toInsert)
            perms.add(newPerm)
        }
    }
    return perms
}

fun main(args: Array<String>) {
    val sieve = IntArray(LIMIT) // all zero by default
    val elements = mutableListOf<String>()
    for (n in 1 until LIMIT) {
        if (sieve[n] > 0) continue
        elements.clear()
        var next = n.toString()
        elements.add(next)
        while (true) {
            next = selfRefSeq(next)
            if (next in elements) {
                val size = elements.size
                sieve[n] = size
                if (n > 9) {
                    val perms = permute(n.toString().toList()).distinct()
                    for (perm in perms) {
                        if (perm[0] == '0') continue
                        val k = perm.joinToString("").toInt()
                        sieve[k] = size
                    }
                }
                break
            }
            elements.add(next)
        }
    }
    val maxIterations = sieve.max()!!
    for (n in 1 until LIMIT) {
        if (sieve[n] < maxIterations) continue
        println("$n -> Iterations = $maxIterations")
        var next = n.toString()
        for (i in 1..maxIterations) {
            println(next)
            next = selfRefSeq(next)
        }
        println()
    }
}
