// version 1.2.10

import java.math.BigInteger

typealias Freq = Map<Char, Long>

val bigZero = BigInteger.ZERO
val bigOne  = BigInteger.ONE

fun cumulativeFreq(freq: Freq): Freq {
    var total = 0L
    val cf = mutableMapOf<Char, Long>()
    for (i in 0..255) {
        val c = i.toChar()
        val v = freq[c]
        if (v != null) {
            cf[c] = total
            total += v
        }
    }
    return cf
}

fun arithmeticCoding(str: String, radix: Long): Triple<BigInteger, Int, Freq> {
    // Convert the string into a char array
    val chars = str.toCharArray()

    // The frequency characters
    val freq = mutableMapOf<Char, Long>()
    for (c in chars) {
        if (c !in freq)
            freq[c] = 1L
        else
            freq[c] = freq[c]!! + 1
    }

    // The cumulative frequency
    val cf = cumulativeFreq(freq)

    // Base
    val base = chars.size.toBigInteger()

    // LowerBound
    var lower = bigZero

    // Product of all frequencies
    var pf = BigInteger.ONE

    // Each term is multiplied by the product of the
    // frequencies of all previously occurring symbols
    for (c in chars) {
        val x = cf[c]!!.toBigInteger()
        lower  = lower * base + x * pf
        pf *= freq[c]!!.toBigInteger()
    }

    // Upper bound
    val upper = lower + pf

    var powr = 0
    val bigRadix = radix.toBigInteger()

    while (true) {
        pf /= bigRadix
        if (pf == bigZero) break
        powr++
    }

    val diff = (upper - bigOne) / bigRadix.pow(powr)
    return Triple(diff, powr, freq)
}

fun arithmeticDecoding(num: BigInteger, radix: Long, pwr: Int, freq: Freq): String {
    val powr = radix.toBigInteger()
    var enc = num * powr.pow(pwr)
    var base = 0L
    for ((_, v) in freq) base += v

    // Create the cumulative frequency table
    val cf = cumulativeFreq(freq)

    // Create the dictionary
    val dict = mutableMapOf<Long, Char>()
    for ((k, v) in cf) dict[v] = k

    // Fill the gaps in the dictionary
    var lchar = -1
    for (i in 0L until base) {
        val v = dict[i]
        if (v != null) {
            lchar = v.toInt()
        }
        else if(lchar != -1) {
            dict[i] = lchar.toChar()
        }
    }

    // Decode the input number
    val decoded = StringBuilder(base.toInt())
    val bigBase = base.toBigInteger()
    for (i in base - 1L downTo 0L) {
        val pow = bigBase.pow(i.toInt())
        val div = enc / pow
        val c = dict[div.toLong()]
        val fv = freq[c]!!.toBigInteger()
        val cv = cf[c]!!.toBigInteger()
        val diff = enc - pow * cv
        enc = diff / fv
        decoded.append(c)
    }
    // Return the decoded output
    return decoded.toString()
}

fun main(args: Array<String>) {
    val radix = 10L
    val strings = listOf(
        "DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"
    )
    val fmt = "%-25s=> %19s * %d^%s"
    for (str in strings) {
        val (enc, pow, freq) = arithmeticCoding(str, radix)
        val dec = arithmeticDecoding(enc, radix, pow, freq)
        println(fmt.format(str, enc, radix, pow))
        if (str != dec) throw Exception("\tHowever that is incorrect!")
    }
}
