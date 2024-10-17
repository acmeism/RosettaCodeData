fun main() {
    val e = (1..17).runningFold(1L, Long::times)
        .asReversed()  // summing smaller values first improves accuracy
        .sumOf { 1.0 / it }
    println(e)
    println(e == kotlin.math.E)
}
