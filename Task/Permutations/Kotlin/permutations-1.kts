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

fun main(args: Array<String>) {
    val input = listOf('a', 'b', 'c', 'd')
    val perms = permute(input)
    println("There are ${perms.size} permutations of $input, namely:\n")
    for (perm in perms) println(perm)
}
