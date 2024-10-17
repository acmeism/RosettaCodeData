tailrec fun A(m: Long, n: Long): Long {
    require(m >= 0L) { "m must not be negative" }
    require(n >= 0L) { "n must not be negative" }
    if (m == 0L) {
        return n + 1L
    }
    if (n == 0L) {
        return A(m - 1L, 1L)
    }
    return A(m - 1L, A(m, n - 1L))
}

inline fun<T> tryOrNull(block: () -> T): T? = try { block() } catch (e: Throwable) { null }

const val N = 10L
const val M = 4L

fun main() {
    (0..M)
        .map { it to 0..N }
        .map { (m, Ns) -> (m to Ns) to Ns.map { n -> tryOrNull { A(m, n) } } }
        .map { (input, output) -> "A(${input.first}, ${input.second})" to output.map { it?.toString() ?: "?" } }
        .map { (input, output) -> "$input = $output" }
        .forEach(::println)
}
