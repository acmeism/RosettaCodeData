// version 1.1.51

import java.math.BigInteger

const val ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
val big0  = BigInteger.ZERO
val big58 = BigInteger.valueOf(58L)

fun convertToBase58(hash: String, base: Int = 16): String {
    var x = if (base == 16 && hash.take(2) == "0x") BigInteger(hash.drop(2), 16)
            else BigInteger(hash, base)
    val sb = StringBuilder()
    while (x > big0) {
        val r = (x % big58).toInt()
        sb.append(ALPHABET[r])
        x = x / big58
    }
    return sb.toString().reversed()
}

fun main(args: Array<String>) {
    val s = "25420294593250030202636073700053352635053786165627414518"
    val b = convertToBase58(s, 10)
    println("$s -> $b")
    val hashes = listOf(
        "0x61",
        "0x626262",
        "0x636363",
        "0x73696d706c792061206c6f6e6720737472696e67",
        "0x516b6fcd0f",
        "0xbf4f89001e670274dd",
        "0x572e4794",
        "0xecac89cad93923c02321",
        "0x10c8511e"
    )
    for (hash in hashes) {
        val b58 = convertToBase58(hash)
        println("${hash.padEnd(56)} -> $b58")
    }
}
