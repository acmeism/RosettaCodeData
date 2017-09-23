// version 1.0.6

fun pythagoreanTriples(n: Int) =
    (1..n).flatMap {
        x -> (x..n).flatMap {
            y -> (y..n).filter {
                z ->  x * x + y * y == z * z
            }.map { Triple(x, y, it) }
        }
    }

fun main(args: Array<String>) {
    println(pythagoreanTriples(20))
}
