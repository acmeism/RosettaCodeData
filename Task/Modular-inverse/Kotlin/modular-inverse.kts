// version 1.0.6

import java.math.BigInteger

fun main(args: Array<String>) {
    val a = BigInteger.valueOf(42)
    val m = BigInteger.valueOf(2017)
    println(a.modInverse(m))
}
