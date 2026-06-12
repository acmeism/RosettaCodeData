class SequenceGenerator {

    companion object {
        fun generateSequence(k: Int, n: Int): String {
            var s = Array(n) { mutableListOf<Int>() }

            for (i in 0 until n) {
                if (i < k) {
                    s[i].add(1)
                } else {
                    s[i].add(0)
                }
            }

            var d = n - k
            var nVar = maxOf(k, d)
            var kVar = minOf(k, d)
            var z = d

            while (z > 0 || kVar > 1) {
                for (i in 0 until kVar) {
                    s[i].addAll(s[s.size - 1 - i])
                }
                s = s.copyOfRange(0, s.size - kVar)
                z -= kVar
                d = nVar - kVar
                nVar = maxOf(kVar, d)
                kVar = minOf(kVar, d)
            }

            val result = s.flatMap { it }.joinToString(separator = "") { it.toString() }
            return result
        }
    }
}

// Example usage
fun main() {
    val result = SequenceGenerator.generateSequence(k = 5, n = 13)
    println(result) // Should print 1001010010100
}
