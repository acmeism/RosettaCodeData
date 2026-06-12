import java.math.BigInteger
import kotlin.math.floor
import kotlin.math.sqrt

val ONE_HUNDRED: BigInteger = BigInteger.valueOf(100)
val TWENTY: BigInteger = BigInteger.valueOf(20)

fun main() {
    var i = BigInteger.TWO
    var j = BigInteger.valueOf(floor(sqrt(2.0)).toLong())
    var k = j
    var d = j
    var n = 500
    val n0 = n
    do {
        print(d)
        i = i.subtract(k.multiply(d)).multiply(ONE_HUNDRED)
        k = TWENTY.multiply(j)
        d = BigInteger.ONE
        while (d <= BigInteger.TEN) {
            if (k.add(d).multiply(d) > i) {
                d = d.subtract(BigInteger.ONE)
                break
            }
            d = d.add(BigInteger.ONE)
        }
        j = j.multiply(BigInteger.TEN).add(d)
        k = k.add(d)
        if (n0 > 0) {
            n--
        }
    } while (n > 0)
    println()
}
