import java.math.BigInteger
import java.util.*

val One = BigInteger.ONE!!
val Three = BigInteger.valueOf(3)!!
val Five = BigInteger.valueOf(5)!!

fun PriorityQueue<BigInteger>.update(x: BigInteger) : PriorityQueue<BigInteger> {
    add(x.shiftLeft(1))
    add(x.multiply(Three))
    add(x.multiply(Five))
    return this
}

fun hamming(n: Int): BigInteger {
    val frontier = PriorityQueue<BigInteger>().update(One)
    var lowest = One
    repeat(n - 1) {
        lowest = frontier.poll() ?: lowest
        while (frontier.peek() == lowest)
            frontier.poll()
        frontier.update(lowest)
    }
    return lowest
}

fun hamming(i : Iterable<Int>) : Iterable<BigInteger> = i.map { hamming(it) }

fun main(args: Array<String>) {
    val r = 1..20
    println("Hamming($r) = " + hamming(r))
    arrayOf(1691, 1000000).forEach { println("Hamming($it) = " + hamming(it)) }
}
