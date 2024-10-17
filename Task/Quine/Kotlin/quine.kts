// version 1.1.2

const val F = """// version 1.1.2

const val F = %c%c%c%s%c%c%c

fun main(args: Array<String>) {
    System.out.printf(F, 34, 34, 34, F, 34, 34, 34)
}
"""

fun main(args: Array<String>) {
    System.out.printf(F, 34, 34, 34, F, 34, 34, 34)
}
