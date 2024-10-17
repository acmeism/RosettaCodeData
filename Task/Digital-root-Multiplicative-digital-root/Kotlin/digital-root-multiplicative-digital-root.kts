// version 1.1.2

fun multDigitalRoot(n: Int): Pair<Int, Int> = when {
        n < 0   -> throw IllegalArgumentException("Negative numbers not allowed")
        else    -> {
            var mdr: Int
            var mp = 0
            var nn = n
            do {
                mdr = if (nn > 0) 1 else 0
                while (nn > 0) {
                    mdr *= nn % 10
                    nn /= 10
                }
                mp++
                nn = mdr
            }
            while (mdr >= 10)
            Pair(mdr, mp)
        }
    }

fun main(args: Array<String>) {
    val ia = intArrayOf(123321, 7739, 893, 899998)
    for (i in ia) {
        val (mdr, mp) = multDigitalRoot(i)
        println("${i.toString().padEnd(9)} MDR = $mdr  MP = $mp")
    }
    println()
    println("MDR   n0    n1    n2    n3    n4")
    println("===  ===========================")
    val ia2 = Array(10) { IntArray(6) } // all zero by default
    var n = 0
    var count = 0
    do {
        val (mdr, _) = multDigitalRoot(n)
        if (ia2[mdr][0] < 5) {
            ia2[mdr][0]++
            ia2[mdr][ia2[mdr][0]] = n
            count++
        }
        n++
    }
    while (count < 50)

    for (i in 0..9) {
        print("$i:")
        for (j in 1..5) print("%6d".format(ia2[i][j]))
        println()
    }
}
