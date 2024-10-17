import java.security.MessageDigest

object Bitcoin {
    private const val ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

    private fun ByteArray.contentEquals(other: ByteArray): Boolean {
        if (this.size != other.size) return false
        return (0 until this.size).none { this[it] != other[it] }
    }

    private fun decodeBase58(input: String): ByteArray? {
        val output = ByteArray(25)
        for (c in input) {
            var p = ALPHABET.indexOf(c)
            if (p == -1) return null
            for (j in 24 downTo 1) {
                p += 58 * (output[j].toInt() and 0xff)
                output[j] = (p % 256).toByte()
                p = p shr 8
            }
            if (p != 0) return null
        }
        return output
    }

    private fun sha256(data: ByteArray, start: Int, len: Int, recursion: Int): ByteArray {
        if (recursion == 0) return data
        val md = MessageDigest.getInstance("SHA-256")
        md.update(data.sliceArray(start until start + len))
        return sha256(md.digest(), 0, 32, recursion - 1)
    }

    fun validateAddress(address: String): Boolean {
        if (address.length !in 26..35) return false
        val decoded = decodeBase58(address)
        if (decoded == null) return false
        val hash = sha256(decoded, 0, 21, 2)
        return hash.sliceArray(0..3).contentEquals(decoded.sliceArray(21..24))
    }
}

fun main(args: Array<String>) {
    val addresses = arrayOf(
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j",
        "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9",
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X",
        "1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
        "1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i",
        "BZbvjr",
        "i55j",
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62!",
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62iz",
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62izz",
        "1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9",
        "1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I"
    )
    for (address in addresses)
        println("${address.padEnd(36)} -> ${if (Bitcoin.validateAddress(address)) "valid" else "invalid"}")
}
