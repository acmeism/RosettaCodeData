// version 1.1.3

import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

fun String.toHexByteArray(): ByteArray {
    val bytes = ByteArray(this.length / 2)
    for (i in 0 until bytes.size) {
        bytes[i] = this.substring(i * 2, i * 2 + 2).toInt(16).toByte()
    }
    return bytes
}

fun ByteArray.printHexBytes(label: String) {
    print("$label: ")
    for (b in this) {
        val bb = if (b >= 0) b.toInt() else b + 256
        print(bb.toString(16).padStart(2, '0'))
    }
    println()
}

fun main(args: Array<String>) {
    val strKey = "0e329232ea6d0d73"
    val keyBytes = strKey.toHexByteArray()
    val key = SecretKeySpec(keyBytes, "DES")
    val encCipher = Cipher.getInstance("DES")
    encCipher.init(Cipher.ENCRYPT_MODE, key)
    val strPlain = "8787878787878787"
    val plainBytes = strPlain.toHexByteArray()
    val encBytes = encCipher.doFinal(plainBytes)
    encBytes.printHexBytes("Encoded")

    val decCipher = Cipher.getInstance("DES")
    decCipher.init(Cipher.DECRYPT_MODE, key)
    val decBytes = decCipher.doFinal(encBytes)
    decBytes.printHexBytes("Decoded")
}
