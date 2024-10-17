fun main(args: Array<String>) {
    val strings = listOf("Here", "are", "some", "sample", "strings", "to", "be", "sorted")
    println("Unsorted: $strings")

    val sorted = strings.map { Triple(it, it.length, it.lowercase()) }.sortedWith { a, b ->
            compareValues(b.second, a.second).let {
                    if (it == 0) compareValues(a.third, b.third)
                    else it
                }
        }.map { it.first }

    println("Sorted: $sorted")
}
