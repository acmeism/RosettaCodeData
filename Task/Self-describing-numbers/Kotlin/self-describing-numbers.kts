// version 1.0.6

fun selfDescribing(n: Int): Boolean {
    if (n <= 0) return false
    val ns = n.toString()
    val count = IntArray(10)
    var nn = n
    while (nn > 0) {
        count[nn % 10] += 1
        nn /= 10
    }
    for (i in 0 until ns.length)
        if( ns[i] - '0' != count[i]) return false
    return true
}

fun main(args: Array<String>) {
    println("The self-describing numbers less than 100 million are:")
    for (i in 0..99999999) if (selfDescribing(i)) print("$i ")
    println()
}
