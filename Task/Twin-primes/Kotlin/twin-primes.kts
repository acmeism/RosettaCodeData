import java.math.BigInteger
import java.util.*

fun main() {
    val input = Scanner(System.`in`)
    println("Search Size: ")
    val max = input.nextBigInteger()
    var counter = 0
    var x = BigInteger("3")
    while (x <= max) {
        val sqrtNum = x.sqrt().add(BigInteger.ONE)
        if (x.add(BigInteger.TWO) <= max) {
            counter += if (findPrime(
                    x.add(BigInteger.TWO),
                    x.add(BigInteger.TWO).sqrt().add(BigInteger.ONE)
                ) && findPrime(x, sqrtNum)
            ) 1 else 0
        }
        x = x.add(BigInteger.ONE)
    }
    println("$counter twin prime pairs.")
}

fun findPrime(x: BigInteger, sqrtNum: BigInteger?): Boolean {
    var divisor = BigInteger.TWO
    while (divisor <= sqrtNum) {
        if (x.remainder(divisor).compareTo(BigInteger.ZERO) == 0) {
            return false
        }
        divisor = divisor.add(BigInteger.ONE)
    }
    return true
}
