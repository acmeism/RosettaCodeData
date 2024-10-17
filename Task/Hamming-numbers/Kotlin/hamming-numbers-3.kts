import java.math.BigInteger
import java.util.*

val One = BigInteger.ONE!!
val Three = BigInteger.valueOf(3)!!
val Five = BigInteger.valueOf(5)!!

infix fun PriorityQueue<BigInteger>.update(x: BigInteger) : PriorityQueue<BigInteger> {
    add(x.shiftLeft(1))
    add(x.multiply(Three))
    add(x.multiply(Five))
    return this
}

fun hamming(a: Any?): Any = when (a) {
    is Number -> {
        val pq = PriorityQueue<BigInteger>() update One
        var lowest = One
        repeat(a.toInt() - 1) {
            lowest = pq.poll() ?: lowest
            while (pq.peek() == lowest) pq.poll()
            pq update lowest
        }
        lowest
    }
    is Iterable<*> -> a.map { hamming(it) }
    else -> throw IllegalArgumentException("cannot parse argument")
}

fun main(args: Array<String>) {
    arrayOf(1..20, 1691, 1000000).forEach { println("Hamming($it) = " + hamming(it)) }
}
