import kotlin.math.ceil
import kotlin.math.sqrt

fun main() {
    val primes = mutableListOf(3L, 5L)
    val cutOff = 200
    val bigUn = 100_000
    val chunks = 50
    val little = bigUn / chunks

    println("The first $cutOff cuban primes:")
    var showEach = true
    var c = 0
    var u = 0L
    var v = 1L
    var i = 1L
    while (i > 0) {
        var found = false
        u += 6
        v += u
        val mx = ceil(sqrt(v.toDouble())).toInt()
        for (item in primes) {
            if (item > mx) break
            if (v % item == 0L) {
                found = true
                break
            }
        }
        if (!found) {
            c++
            if (showEach) {
                var z = primes.last() + 2
                while (z <= v - 2) {
                    var fnd = false
                    for (item in primes) {
                        if (item > mx) break
                        if (z % item == 0L) {
                            fnd = true
                            break
                        }
                    }
                    if (!fnd) {
                        primes.add(z)
                    }
                    z += 2
                }
                primes.add(v)
                print("%11d".format(v))
                if (c % 10 == 0) println()
                if (c == cutOff) {
                    showEach = false
                    print("\nProgress to the ${bigUn}th cuban prime: ")
                }
            }
            if (c % little == 0) {
                print(".")
                if (c == bigUn) break
            }
        }
        i++
    }
    println("\nThe %dth cuban prime is %17d".format(c, v))
}
