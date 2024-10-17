fun hailstone(start: Int) = generateSequence(start) { n ->
    when {
        n == 1     -> null
        n % 2 == 0 -> n / 2
        else       -> n * 3 + 1
    }
}

fun main() {
    val hail27 = hailstone(27).toList()
    println("The hailstone sequence for 27 has ${hail27.size} elements:\n$hail27")

    val (n, length) = (1..100000).asSequence()
        .map { it to hailstone(it).count() }
        .maxBy { it.second }
    println("The number between 1 and 100000 with the longest hailstone sequence is $n, of length $length")
}
