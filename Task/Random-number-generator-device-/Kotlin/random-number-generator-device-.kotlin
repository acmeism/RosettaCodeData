// version 1.1.2

import java.security.SecureRandom

fun main(args: Array<String>) {
    val rng = SecureRandom()
    val rn1 = rng.nextInt()
    val rn2 = rng.nextInt()
    val newSeed = rn1.toLong() * rn2
    rng.setSeed(newSeed)    // reseed using the previous 2 random numbers
    println(rng.nextInt())  // get random 32-bit number and print it
}
