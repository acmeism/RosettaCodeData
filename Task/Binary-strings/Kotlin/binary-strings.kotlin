class ByteString(private val bytes: ByteArray) : Comparable<ByteString> {
    val length get() = bytes.size

    fun isEmpty() = bytes.isEmpty()

    operator fun plus(other: ByteString): ByteString = ByteString(bytes + other.bytes)

    operator fun plus(byte: Byte) = ByteString(bytes + byte)

    operator fun get(index: Int): Byte {
        require (index in 0 until length)
        return bytes[index]
    }

    fun toByteArray() = bytes

    fun copy() = ByteString(bytes.copyOf())

    override fun compareTo(other: ByteString) = this.toString().compareTo(other.toString())

    override fun equals(other: Any?): Boolean {
        if (other == null || other !is ByteString) return false
        return compareTo(other) == 0
    }

    override fun hashCode() = this.toString().hashCode()

    fun substring(startIndex: Int) = ByteString(bytes.sliceArray(startIndex until length))

    fun substring(startIndex: Int, endIndex: Int) =
        ByteString(bytes.sliceArray(startIndex until endIndex))

    fun replace(oldByte: Byte, newByte: Byte): ByteString {
        val ba = ByteArray(length) { if (bytes[it] == oldByte) newByte else bytes[it] }
        return ByteString(ba)
    }

    fun replace(oldValue: ByteString, newValue: ByteString) =
        this.toString().replace(oldValue.toString(), newValue.toString()).toByteString()

    override fun toString(): String {
        val chars = CharArray(length)
        for (i in 0 until length) {
            chars[i] = when (bytes[i]) {
                in 0..127  -> bytes[i].toChar()
                else       -> (256 + bytes[i]).toChar()
            }
        }
        return chars.joinToString("")
    }
}

fun String.toByteString(): ByteString {
    val bytes = ByteArray(this.length)
    for (i in 0 until this.length) {
        bytes[i] = when (this[i].toInt()) {
            in 0..127   -> this[i].toByte()
            in 128..255 -> (this[i] - 256).toByte()
            else        -> '?'.toByte()  // say
        }
    }
    return ByteString(bytes)
}

/* property to be used as an abbreviation for String.toByteString() */
val String.bs get() = this.toByteString()

fun main(args: Array<String>) {
    val ba  = byteArrayOf(65, 66, 67)
    val ba2 = byteArrayOf(68, 69, 70)
    val bs  = ByteString(ba)
    val bs2 = ByteString(ba2)
    val bs3 = bs + bs2
    val bs4 = "GHI£€".toByteString()
    println("The length of $bs is ${bs.length}")
    println("$bs + $bs2 = $bs3")
    println("$bs + D = ${bs + 68}")
    println("$bs == ABC is ${bs == bs.copy()}")
    println("$bs != ABC is ${bs != bs.copy()}")
    println("$bs >= $bs2 is ${bs > bs2}")
    println("$bs <= $bs2 is ${bs < bs2}")
    println("$bs is ${if (bs.isEmpty()) "empty" else "not empty"}")
    println("ABC[1] = ${bs[1].toChar()}")
    println("ABC as a byte array is ${bs.toByteArray().contentToString()}")
    println("ABCDEF(1..5) = ${bs3.substring(1)}")
    println("ABCDEF(2..4) = ${bs3.substring(2,5)}")
    println("ABCDEF with C replaced by G is ${bs3.replace(67, 71)}")
    println("ABCDEF with CD replaced by GH is ${bs3.replace("CD".bs, "GH".bs)}")
    println("GHI£€ as a ByteString is $bs4")
}
