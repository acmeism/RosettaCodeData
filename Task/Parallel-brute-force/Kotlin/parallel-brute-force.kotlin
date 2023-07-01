// version 1.1.51

import java.security.MessageDigest

fun stringHashToByteHash(hash: String): ByteArray {
    val ba = ByteArray(32)
    for (i in 0 until 64 step 2) ba[i / 2] = hash.substring(i, i + 2).toInt(16).toByte()
    return ba
}

fun ByteArray.matches(other: ByteArray): Boolean {
    for (i in 0 until 32) {
        if (this[i] != other[i]) return false
    }
    return true
}

fun main(args: Array<String>) {
    val stringHashes = listOf(
        "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
        "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
        "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"
    )
    val byteHashes = List(3) { stringHashToByteHash(stringHashes[it]) }
    val letters = List(26) { (97 + it).toByte() }

    letters.stream().parallel().forEach {
        val md = MessageDigest.getInstance("SHA-256")
        val range = 97..122
        val pwd = ByteArray(5)
        pwd[0] = it
        for (i1 in range) {
            pwd[1] = i1.toByte()
            for (i2 in range) {
                pwd[2] = i2.toByte()
                for (i3 in range) {
                    pwd[3] = i3.toByte()
                    for (i4 in range) {
                        pwd[4] = i4.toByte()
                        val ba = md.digest(pwd)
                        for (j in 0..2) {
                            if (ba.matches(byteHashes[j])) {
                                val password = pwd.toString(Charsets.US_ASCII)
                                println("$password => ${stringHashes[j]}")
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
