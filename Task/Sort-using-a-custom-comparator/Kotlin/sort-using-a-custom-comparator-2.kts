fun main(args: Array<String>) {
    val strings = listOf("Here", "are", "some", "sample", "strings", "to", "be", "sorted")
    println("Unsorted: $strings")

    // sort by content first then by length => no need for a custom comparator since sortedByDescending is stable
    val sorted = strings.sortedBy { it.lowercase() }.sortedByDescending { it.length }

    println("Sorted: $sorted")
}
