import kotlin.math.*
val oddPrimes = generateSequence(3) {it + 2}
    .filter{p -> (3..ceil(sqrt(p.toDouble())).toInt() step 2).all{p % it > 0}}
val primes = sequenceOf(2) + oddPrimes

fun isPrime(n: Int): Boolean {
    return when (n < 5) {
    	true -> n or 1 == 3
    	else -> primes.takeWhile{it <= sqrt(n.toDouble())}.all{n % it > 0}
    }
}

val factorials = generateSequence(Pair(1,2)) {(f, i) -> Pair(f * i, i + 1)}
       .map{it.first}

val erdos = primes.filter{p -> factorials.takeWhile{it < p}.all{!isPrime(p - it)}}

fun main() {
    val limit = 2500
    println("erdös primes less than $limit are")
    erdos.takeWhile{it <= limit}.chunked(10).forEach {
        println(it.map{"%4d".format(it)}.joinToString(" "))
    }
    val (index, less1e6) = erdos.takeWhile{it < 1_000_000}.withIndex().last()
    println("...\nerdös(${index + 1}) is $less1e6")
}   // © 2026
