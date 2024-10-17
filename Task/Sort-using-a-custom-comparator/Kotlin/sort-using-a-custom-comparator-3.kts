fun main(args: Array<String>) {
    val strings = listOf("Here", "are", "some", "sample", "strings", "to", "be", "sorted")
    println("Unsorted: $strings")

    val sorted = strings.sortedWith { a, b ->
            compareValues(b.length, a.length).let {
                if (it == 0) compareValues(a.lowercase(), b.lowercase())
                else it
            }
        }

    println("Sorted: $sorted")
}
