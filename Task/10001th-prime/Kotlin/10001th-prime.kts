import kotlin.math.*

val oddPrimes = generateSequence(3) {it + 2}
    .filter{p -> (3 .. ceil(sqrt(p.toDouble())).toInt() step 2).all{p % it > 0}}

val primes = sequenceOf(2) + oddPrimes
val index = 10001

fun main() {
    println("prime($index) is " + primes.drop(index - 1).first())
}
