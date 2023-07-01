// version 1.0.6

import java.math.BigInteger

const val ITERATIONS = 500
const val LIMIT = 10000

val bigLimit = BigInteger.valueOf(LIMIT.toLong())

// In the sieve,  0 = not Lychrel, 1 = Seed Lychrel, 2 = Related Lychrel
val lychrelSieve    = IntArray(LIMIT + 1)  // all zero by default
val seedLychrels    = mutableListOf<Int>()
val relatedLychrels = mutableSetOf<BigInteger>()

fun isPalindrome(bi: BigInteger): Boolean {
    val s = bi.toString()
    return s == s.reversed()
}

fun lychrelTest(i: Int, seq: MutableList<BigInteger>){
    if (i < 1) return
    var bi = BigInteger.valueOf(i.toLong())
    (1 .. ITERATIONS).forEach {
        bi += BigInteger(bi.toString().reversed())
        seq.add(bi)
        if (isPalindrome(bi)) return
    }
    for (j in 0 until seq.size) {
        if (seq[j] <= bigLimit) lychrelSieve[seq[j].toInt()] = 2
        else break
    }
    val sizeBefore = relatedLychrels.size
    relatedLychrels.addAll(seq)  // if all of these can be added 'i' must be a seed Lychrel
    if (relatedLychrels.size - sizeBefore == seq.size) {
        seedLychrels.add(i)
        lychrelSieve[i] = 1
    }
    else {
        relatedLychrels.add(BigInteger.valueOf(i.toLong()))
        lychrelSieve[i] = 2
    }
}

fun main(args: Array<String>) {
    val seq  = mutableListOf<BigInteger>()
    for (i in 1 .. LIMIT)
        if (lychrelSieve[i] == 0) {
           seq.clear()
           lychrelTest(i, seq)
        }
    var related = lychrelSieve.count { it == 2 }
    println("Lychrel numbers in the range [1, $LIMIT]")
    println("Maximum iterations = $ITERATIONS")
    println("\nThere are ${seedLychrels.size} seed Lychrel numbers, namely")
    println(seedLychrels)
    println("\nThere are also $related related Lychrel numbers in this range")
    val palindromes = mutableListOf<Int>()
    for (i in 1 .. LIMIT)
        if (lychrelSieve[i] > 0 && isPalindrome(BigInteger.valueOf(i.toLong()))) palindromes.add(i)
    println("\nThere are ${palindromes.size} palindromic Lychrel numbers, namely")
    println(palindromes)
}
