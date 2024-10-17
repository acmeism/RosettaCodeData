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

fun <T> missingPerms(input: List<T>, perms: List<List<T>>) = permute(input) - perms

fun main(args: Array<String>) {
    val input = listOf('A', 'B', 'C', 'D')
    val strings = listOf(
        "ABCD", "CABD", "ACDB", "DACB", "BCDA", "ACBD", "ADCB", "CDAB",
        "DABC", "BCAD", "CADB", "CDBA", "CBAD", "ABDC", "ADBC", "BDCA",
        "DCBA", "BACD", "BADC", "BDAC", "CBDA", "DBCA", "DCAB"
    )
    val perms = strings.map { it.toList() }
    val missing = missingPerms(input, perms)
    if (missing.size == 1)
        print("The missing permutation is ${missing[0].joinToString("")}")
    else {
        println("There are ${missing.size} missing permutations, namely:\n")
        for (perm in missing) println(perm.joinToString(""))
    }
}
