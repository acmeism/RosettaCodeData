// version 1.0.6

import java.security.MessageDigest

fun main(args: Array<String>) {
    val text  = "Rosetta Code"
    val bytes = text.toByteArray()
    val md = MessageDigest.getInstance("SHA-1")
    val digest = md.digest(bytes)
    for (byte in digest) print("%02x".format(byte))
    println()
}
