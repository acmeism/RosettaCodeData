// version 1.1.2

fun isSemiPrime(n: Int): Boolean {
    var nf = 0
    var nn = n
    for (i in 2..nn)
        while (nn % i == 0) {
            if (nf == 2) return false
            nf++
            nn /= i
        }
    return nf == 2
}

fun main(args: Array<String>) {
    for (v in 1675..1680)
        println("$v ${if (isSemiPrime(v)) "is" else "isn't"} semi-prime")
}
