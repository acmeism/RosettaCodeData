// version 1.1.0

import java.math.BigInteger

fun Long.rlwb() = when {
        this <= 0L -> throw IllegalArgumentException("Receiver must be positive")
        else       -> java.lang.Long.numberOfTrailingZeros(this)
    }

fun Long.ruwb() = when {
        this <= 0L -> throw IllegalArgumentException("Receiver must be positive")
        else       -> 63 - java.lang.Long.numberOfLeadingZeros(this)
    }

fun BigInteger.rlwb() = when {
        this <= BigInteger.ZERO -> throw IllegalArgumentException("Receiver must be positive")
        else                    -> this.lowestSetBit
    }

fun BigInteger.ruwb() = when {
        this <= BigInteger.ZERO -> throw IllegalArgumentException("Receiver must be positive")
        else                    -> this.bitLength() - 1
    }

fun main(args: Array<String>) {
    var pow42 = 1L
    for (i in 0..11) {
        print("42 ^ ${i.toString().padEnd(2)}  = ${pow42.toString(2).padStart(64, '0').padEnd(64)} -> ")
        println("MSB: %2d, LSB: %2d".format(pow42.ruwb(), pow42.rlwb()))
        pow42 *= 42L
    }
    println()
    val big1302 = BigInteger.valueOf(1302)
    var pow1302 = BigInteger.ONE
    for (i in 0..6) {
        print("1302 ^ $i = ${pow1302.toString(2).padStart(64, '0').padEnd(64)} -> ")
        println("MSB: %2d, LSB: %2d".format(pow1302.ruwb(), pow1302.rlwb()))
        pow1302 *= big1302
    }
}
