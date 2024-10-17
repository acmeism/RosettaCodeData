// version 1.1.2

fun <T> permute(input: List<T>): List<List<T>> {
    if (input.size == 1) return listOf(input)
    val perms = mutableListOf<List<T>>()
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

fun derange(input: List<Int>): List<List<Int>> {
    if (input.isEmpty()) return listOf(input)
    return permute(input).filter { permutation ->
        permutation.filterIndexed { i, index -> i == index }.none()
    }
}

fun subFactorial(n: Int): Long =
    when (n) {
        0 -> 1
        1 -> 0
        else -> (n - 1) * (subFactorial(n - 1) + subFactorial(n - 2))
    }

fun main(args: Array<String>) {
    val input = listOf(0, 1, 2, 3)

    val derangements = derange(input)
    println("There are ${derangements.size} derangements of $input, namely:\n")
    derangements.forEach(::println)

    println("\nN  Counted   Calculated")
    println("-  -------   ----------")
    for (n in 0..9) {
        val list = List(n) { it }
        val counted = derange(list).size
        println("%d  %-9d %-9d".format(n, counted, subFactorial(n)))
    }
    println("\n!20 = ${subFactorial(20)}")
}
