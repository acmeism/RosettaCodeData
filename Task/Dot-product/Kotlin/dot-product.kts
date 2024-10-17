fun dot(v1: Array<Double>, v2: Array<Double>) =
    v1.zip(v2).map { it.first * it.second }.reduce { a, b -> a + b }

fun main(args: Array<String>) {
    dot(arrayOf(1.0, 3.0, -5.0), arrayOf(4.0, -2.0, -1.0)).let { println(it) }
}
