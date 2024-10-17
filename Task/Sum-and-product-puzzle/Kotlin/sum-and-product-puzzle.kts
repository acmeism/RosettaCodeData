// version 1.1.4-3

data class P(val x: Int, val y: Int, val sum: Int, val prod: Int)

fun main(args: Array<String>) {
    val candidates = mutableListOf<P>()
    for (x in 2..49) {
        for (y in x + 1..100 - x) {
            candidates.add(P(x, y, x + y, x * y))
        }
    }

    val sums = candidates.groupBy { it.sum }
    val prods = candidates.groupBy { it.prod }

    val fact1 = candidates.filter { sums[it.sum]!!.all { prods[it.prod]!!.size > 1 } }
    val fact2 = fact1.filter { prods[it.prod]!!.intersect(fact1).size == 1 }
    val fact3 = fact2.filter { sums[it.sum]!!.intersect(fact2).size == 1 }
    print("The only solution is : ")
    for ((x, y, _, _) in fact3) println("x = $x, y = $y")
}
