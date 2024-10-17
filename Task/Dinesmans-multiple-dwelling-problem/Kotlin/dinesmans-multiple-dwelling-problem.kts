// version 1.1.3

typealias Predicate = (List<String>) -> Boolean

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

/* looks for for all possible solutions, not just the first */
fun dinesman(occupants: List<String>, predicates: List<Predicate>) =
    permute(occupants).filter { perm -> predicates.all { pred -> pred(perm) } }

fun main(args: Array<String>) {
    val occupants = listOf("Baker", "Cooper", "Fletcher", "Miller", "Smith")

    val predicates = listOf<Predicate>(
        { it.last() != "Baker" },
        { it.first() != "Cooper" },
        { it.last() != "Fletcher" && it.first() != "Fletcher" },
        { it.indexOf("Miller") > it.indexOf("Cooper") },
        { Math.abs(it.indexOf("Smith") - it.indexOf("Fletcher")) > 1 },
        { Math.abs(it.indexOf("Fletcher") - it.indexOf("Cooper")) > 1 }
    )

    val solutions = dinesman(occupants, predicates)
    val size = solutions.size
    if (size == 0) {
        println("No solutions found")
    }
    else {
        val plural = if (size == 1) "" else "s"
        println("$size solution$plural found, namely:\n")
        for (solution in solutions) {
            for ((i, name) in solution.withIndex()) {
                println("Floor ${i + 1} -> $name")
            }
            println()
        }
    }
}
