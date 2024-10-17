// version 1.1.2

fun main(args: Array<String>) {
    val s = "100"
    val bases = intArrayOf(2, 8, 10, 16, 19, 36)
    for (base in bases)
        println("$s in base ${"%2d".format(base)} is ${s.toInt(base)}")
}
