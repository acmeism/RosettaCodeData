fun main(args: Array<String>) {
    val p5 = LongArray(250){ it.toLong() * it * it * it * it }
    var sum: Long
    var y: Int
    var found = false
    loop@ for (x0 in 0 .. 249)
        for (x1 in 0 .. x0 - 1)
            for (x2 in 0 .. x1 - 1)
                for (x3 in 0 .. x2 - 1) {
                    sum = p5[x0] + p5[x1] + p5[x2] + p5[x3]
                    y = p5.binarySearch(sum)
                    if (y >= 0) {
                        println("$x0^5 + $x1^5 + $x2^5 + $x3^5 = $y^5")
                        found = true
                        break@loop
                    }
                }
    if (!found) println("No solution was found")
}
