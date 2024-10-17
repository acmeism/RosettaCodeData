// Version 1.2.71

fun mcnugget(limit: Int) {
    val sv = BooleanArray(limit + 1)  // all false by default
    for (s in 0..limit step 6)
        for (n in s..limit step 9)
            for (t in n..limit step 20) sv[t] = true

    for (i in limit downTo 0) {
        if (!sv[i]) {
            println("Maximum non-McNuggets number is $i")
            return
        }
    }
}

fun main(args: Array<String>) {
    mcnugget(100)
}
