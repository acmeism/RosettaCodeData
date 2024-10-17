// version 1.1.4-3

fun Byte.toUInt()  = java.lang.Byte.toUnsignedInt(this)

fun Byte.toULong() = java.lang.Byte.toUnsignedLong(this)

fun Int.toULong()  = java.lang.Integer.toUnsignedLong(this)

val s = arrayOf(
    byteArrayOf( 4, 10,  9,  2, 13,  8,  0, 14,  6, 11,  1, 12,  7, 15,  5,  3),
    byteArrayOf(14, 11,  4, 12,  6, 13, 15, 10,  2,  3,  8,  1,  0,  7,  5,  9),
    byteArrayOf( 5,  8,  1, 13, 10,  3,  4,  2, 14, 15, 12,  7,  6,  0,  9, 11),
    byteArrayOf( 7, 13, 10,  1,  0,  8,  9, 15, 14,  4,  6, 12, 11,  2,  5,  3),
    byteArrayOf( 6, 12,  7,  1,  5, 15, 13,  8,  4, 10,  9, 14,  0,  3, 11,  2),
    byteArrayOf( 4, 11, 10,  0,  7,  2,  1, 13,  3,  6,  8,  5,  9, 12, 15, 14),
    byteArrayOf(13, 11,  4,  1,  3, 15,  5,  9,  0, 10, 14,  7,  6,  8,  2, 12),
    byteArrayOf( 1, 15, 13,  0,  5,  7, 10,  4,  9,  2,  3, 14,  6, 11,  8, 12)
)

class Gost(val sBox: Array<ByteArray>) {

    val k87 = ByteArray(256)
    val k65 = ByteArray(256)
    val k43 = ByteArray(256)
    val k21 = ByteArray(256)
    val enc = ByteArray(8)

    init {
        for (i in 0 until 256) {
            val j = i ushr 4
            val k = i and 15
            k87[i] = ((sBox[7][j].toUInt() shl 4) or sBox[6][k].toUInt()).toByte()
            k65[i] = ((sBox[5][j].toUInt() shl 4) or sBox[4][k].toUInt()).toByte()
            k43[i] = ((sBox[3][j].toUInt() shl 4) or sBox[2][k].toUInt()).toByte()
            k21[i] = ((sBox[1][j].toUInt() shl 4) or sBox[0][k].toUInt()).toByte()
        }
    }

    fun f(x: Int): Int {
        val y = (k87[(x ushr 24) and 255].toULong() shl 24) or
                (k65[(x ushr 16) and 255].toULong() shl 16) or
                (k43[(x ushr  8) and 255].toULong() shl  8) or
                (k21[ x and 255].toULong())
        return ((y shl 11) or (y ushr 21)).toInt()
    }

    fun u32(ba: ByteArray): Int =
        (ba[0].toULong() or
        (ba[1].toULong() shl 8) or
        (ba[2].toULong() shl 16) or
        (ba[3].toULong() shl 24)).toInt()

    fun b4(u: Int) {
        enc[0] = u.toByte()
        enc[1] = (u ushr  8).toByte()
        enc[2] = (u ushr 16).toByte()
        enc[3] = (u ushr 24).toByte()
    }

    fun mainStep(input: ByteArray, key: ByteArray) {
        val key32  = u32(key)
        val input1 = u32(input.sliceArray(0..3))
        val input2 = u32(input.sliceArray(4..7))
        val temp   = (key32.toULong() + input1.toULong()).toInt()
        b4(f(temp) xor input2)
        for (i in 0..3) enc[4 + i] = input[i]
    }
}

fun main(args: Array<String>) {
    val input = byteArrayOf(0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04)
    val key = byteArrayOf(0xF9.toByte(), 0x04, 0xC1.toByte(), 0xE2.toByte())
    val g = Gost(s)
    g.mainStep(input, key)
    for (b in g.enc) print("[%02X]".format(b))
    println()
}
