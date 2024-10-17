// version 1.0.6

import java.security.MessageDigest

fun main(args: Array<String>) {
    val text  = "The quick brown fox jumped over the lazy dog's back"
    val bytes = text.toByteArray()
    val md = MessageDigest.getInstance("MD5")
    val digest = md.digest(bytes)
    for (byte in digest) print("%02x".format(byte))
    println()
}
