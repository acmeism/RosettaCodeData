import java.math.BigInteger

fun main() {
    // Using a 64-bit unsigned type, print until 18446744073709551615
    (1u..ULong.MAX_VALUE).forEach { println(it) }

    // Using unlimited-size integers, print forever
    var n = BigInteger.ONE
    while (true) println(n++)
}
