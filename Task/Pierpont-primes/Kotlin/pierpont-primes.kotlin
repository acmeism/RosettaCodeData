import java.math.BigInteger
import kotlin.math.min

val one: BigInteger = BigInteger.ONE
val two: BigInteger = BigInteger.valueOf(2)
val three: BigInteger = BigInteger.valueOf(3)

fun pierpont(n: Int): List<List<BigInteger>> {
    val p = List(2) { MutableList(n) { BigInteger.ZERO } }
    p[0][0] = two
    var count = 0
    var count1 = 1
    var count2 = 0
    val s = mutableListOf<BigInteger>()
    s.add(one)
    var i2 = 0
    var i3 = 0
    var k = 1
    var n2: BigInteger
    var n3: BigInteger
    var t: BigInteger
    while (count < n) {
        n2 = s[i2] * two
        n3 = s[i3] * three
        if (n2 < n3) {
            t = n2
            i2++
        } else {
            t = n3
            i3++
        }
        if (t > s[k - 1]) {
            s.add(t)
            k++
            t += one
            if (count1 < n && t.isProbablePrime(10)) {
                p[0][count1] = t
                count1++
            }
            t -= two
            if (count2 < n && t.isProbablePrime(10)) {
                p[1][count2] = t
                count2++
            }
            count = min(count1, count2)
        }
    }
    return p
}

fun main() {
    val p = pierpont(2000)

    println("First 50 Pierpont primes of the first kind:")
    for (i in 0 until 50) {
        print("%8d ".format(p[0][i]))
        if ((i - 9) % 10 == 0) {
            println()
        }
    }

    println("\nFirst 50 Pierpont primes of the second kind:")
    for (i in 0 until 50) {
        print("%8d ".format(p[1][i]))
        if ((i - 9) % 10 == 0) {
            println()
        }
    }

    println("\n250th Pierpont prime of the first kind: ${p[0][249]}")
    println("\n250th Pierpont prime of the first kind: ${p[1][249]}")

    println("\n1000th Pierpont prime of the first kind: ${p[0][999]}")
    println("\n1000th Pierpont prime of the first kind: ${p[1][999]}")

    println("\n2000th Pierpont prime of the first kind: ${p[0][1999]}")
    println("\n2000th Pierpont prime of the first kind: ${p[1][1999]}")
}
