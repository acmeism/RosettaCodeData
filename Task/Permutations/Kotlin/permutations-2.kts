fun <T> List<T>.rotateLeft(n: Int) = drop(n) + take(n)

fun <T> permute(input: List<T>): List<List<T>> =
    when (input.isEmpty()) {
        true -> listOf(input)
        else -> {
            permute(input.drop(1))
                .map { it + input.first() }
                .flatMap { subPerm -> List(subPerm.size) { i -> subPerm.rotateLeft(i) } }
        }
    }

fun main(args: Array<String>) {
    permute(listOf(1, 2, 3)).also {
        println("""There are ${it.size} permutations:
            |${it.joinToString(separator = "\n")}""".trimMargin())
    }
}
