// version 1.1.2

val table = arrayOf(
    intArrayOf(0, 3, 1,	7, 5, 9, 8, 6, 4, 2),
    intArrayOf(7, 0, 9, 2, 1, 5, 4, 8, 6, 3),
    intArrayOf(4, 2, 0, 6, 8, 7, 1, 3, 5, 9),
    intArrayOf(1, 7, 5, 0, 9, 8, 3, 4, 2, 6),
    intArrayOf(6, 1, 2, 3, 0, 4, 5, 9, 7, 8),
    intArrayOf(3, 6, 7, 4, 2, 0, 9, 5, 8, 1),
    intArrayOf(5, 8, 6, 9, 7, 2, 0, 1, 3, 4),
    intArrayOf(8, 9, 4, 5, 3, 6, 2, 0, 1, 7),
    intArrayOf(9, 4, 3, 8, 6, 1, 7, 2, 0, 5),
    intArrayOf(2, 5, 8, 1, 4, 3, 6, 7, 9, 0)
)

fun damm(s: String): Boolean {
    var interim = 0
    for (c in s) interim = table[interim][c - '0']
    return interim == 0
}

fun main(args: Array<String>) {
    val numbers = intArrayOf(5724, 5727, 112946, 112949)
    for (number in numbers) {
        val isValid = damm(number.toString())
        println("${"%6d".format(number)} is ${if (isValid) "valid" else "invalid"}")
    }
}
