// Version 1.2.60

fun gcd(a: Int, b: Int): Int {
    var aa = a
    var bb = b
    while (aa != bb) {
        if (aa > bb)
            aa -= bb
        else
            bb -= aa
    }
    return aa
}

const val LIMIT = 100

fun main(args: Array<String>) {
    val starts = listOf(2, 5, 7, 9, 10)
    val ekg = Array(5) { IntArray(LIMIT) }

    for ((s, start) in starts.withIndex()) {
        ekg[s][0] = 1
        ekg[s][1] = start
        for (n in 2 until LIMIT) {
            var i = 2
            while (true) {
                // a potential sequence member cannot already have been used
                // and must have a factor in common with previous member
                if (!ekg[s].slice(0 until n).contains(i) &&
                    gcd(ekg[s][n - 1], i) > 1) {
                        ekg[s][n] = i
                        break
                }
                i++
            }
        }
        System.out.printf("EKG(%2d): %s\n", start, ekg[s].slice(0 until 30))
    }

    // now compare EKG5 and EKG7 for convergence
    for (i in 2 until LIMIT) {
        if (ekg[1][i] == ekg[2][i] &&
        ekg[1].slice(0 until i).sorted() == ekg[2].slice(0 until i).sorted()) {
            println("\nEKG(5) and EKG(7) converge at term ${i + 1}")
            return
        }
    }
    println("\nEKG5(5) and EKG(7) do not converge within $LIMIT terms")
}
