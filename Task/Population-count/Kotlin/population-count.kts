// version 1.0.6

fun popCount(n: Long) = when {
    n < 0L -> throw IllegalArgumentException("n must be non-negative")
    else   -> java.lang.Long.bitCount(n)
}

fun main(args: Array<String>) {
    println("The population count of the first 30 powers of 3 are:")
    var pow3 = 1L
    for (i in 1..30) {
        print("${popCount(pow3)} ")
        pow3 *= 3L
    }
    println("\n")
    println("The first thirty evil numbers are:")
    var count = 0
    var i = 0
    while (true) {
        val pc = popCount(i.toLong())
        if (pc % 2 == 0) {
           print("$i ")
           if (++count == 30) break
        }
        i++
    }
    println("\n")
    println("The first thirty odious numbers are:")
    count = 0
    i = 1
    while (true) {
        val pc = popCount(i.toLong())
        if (pc % 2 == 1) {
            print("$i ")
            if (++count == 30) break
        }
        i++
    }
    println()
}
