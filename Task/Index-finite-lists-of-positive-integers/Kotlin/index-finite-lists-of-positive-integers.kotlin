// version 1.1.2

import java.math.BigInteger

/* Separates each integer in the list with an 'a' then encodes in base 11. Empty list mapped to '-1' */
fun rank(li: List<Int>) = when (li.size) {
    0    -> -BigInteger.ONE
    else ->  BigInteger(li.joinToString("a"), 11)
}

fun unrank(r: BigInteger) = when (r) {
    -BigInteger.ONE -> emptyList<Int>()
    else            -> r.toString(11).split('a').map { if (it != "") it.toInt() else 0 }
}


/* Each integer n in the list mapped to '1' plus n '0's. Empty list mapped to '0' */
fun rank2(li:List<Int>): BigInteger {
    if (li.isEmpty()) return BigInteger.ZERO
    val sb = StringBuilder()
    for (i in li) sb.append("1" + "0".repeat(i))
    return BigInteger(sb.toString(), 2)
}

fun unrank2(r: BigInteger) = when (r) {
    BigInteger.ZERO -> emptyList<Int>()
    else            -> r.toString(2).drop(1).split('1').map { it.length }
}

fun main(args: Array<String>) {
    var li: List<Int>
    var r: BigInteger
    li = listOf(0, 1, 2, 3, 10, 100, 987654321)
    println("Before ranking   : $li")
    r = rank(li)
    println("Rank = $r")
    li = unrank(r)
    println("After unranking  : $li")

    println("\nAlternative approach (not suitable for large numbers)...\n")
    li = li.dropLast(1)
    println("Before ranking   : $li")
    r = rank2(li)
    println("Rank = $r")
    li = unrank2(r)
    println("After unranking  : $li")

    println()
    for (i in 0..10) {
        val bi = BigInteger.valueOf(i.toLong())
        li = unrank2(bi)
        println("${"%2d".format(i)} -> ${li.toString().padEnd(9)} -> ${rank2(li)}")
    }
}
