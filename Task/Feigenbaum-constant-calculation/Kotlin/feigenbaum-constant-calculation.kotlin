// Version 1.2.40

fun feigenbaum() {
    val maxIt = 13
    val maxItJ = 10
    var a1 = 1.0
    var a2 = 0.0
    var d1 = 3.2
    println(" i       d")
    for (i in 2..maxIt) {
        var a = a1 + (a1 - a2) / d1
        for (j in 1..maxItJ) {
            var x = 0.0
            var y = 0.0
            for (k in 1..(1 shl i)) {
                 y = 1.0 - 2.0 * y * x
                 x = a - x * x
            }
            a -= x / y
        }
        val d = (a1 - a2) / (a - a1)
        println("%2d    %.8f".format(i,d))
        d1 = d
        a2 = a1
        a1 = a
    }
}

fun main(args: Array<String>) {
    feigenbaum()
}
